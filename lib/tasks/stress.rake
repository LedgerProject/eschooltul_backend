FakeReport = Struct.new(:id, :content_hash)

namespace :stress do
  desc "Stress apiroom with lots of data"
  task :apiroom, %i[rps time fake file] => :environment do
    args = Stress.parse_args

    rps = args[:rps].to_i
    puts "Using rps: #{rps}"
    time = args[:time].to_i
    puts "Using time: #{time}"
    file = Stress.ensure_file(args[:file])
    puts "Using file: #{file}(.html/.json)"

    puts "Stressing apiroom..."
    simple_test = GasLoadTestCustom.new({ client: rps * time, time: })
    if args[:fake]
      puts "With fake data"
      simple_test.run(output: true, file_name: "#{file}.html") do
        Stress.send_report(FakeReport.new(
                             SecureRandom.uuid,
                             Digest::SHA256.hexdigest(SecureRandom.base64(24))
                           ))
      end
    else
      puts "With real data"
      reports = Stress.find_reports(rps * time).to_a
      if reports.size < rps * time
        puts "Insuficient reports: #{reports.size} created, #{rps * time} needed"
        exit
      end

      puts "Removing transaction_id..."
      Stress.remove_transaction_id

      report_transaction = {}
      simple_test.run(output: true, file_name: "#{file}.html") do |i|
        report = reports[i]
        response = Stress.send_report(report)
        report_transaction[report.id] = response["transactionId"]
      end

      reports.each do |report|
        transaction_id = report_transaction[report.id]
        report.update(transaction_id:)
      end
    end

    Stress.fix_result_table("#{file}.html")

    Stress.save_json(simple_test, "#{file}.json")
    exit
  end
end

class Stress
  def self.fix_result_table(file_name)
    text = File.read(file_name)
    new_contents = text.gsub(/&lt;/, "<")
    new_contents = new_contents.gsub(/&quot;/, "\"")
    new_contents = new_contents.gsub(/&gt;/, ">")

    File.open(file_name, "w") { |file| file.puts new_contents }
  end

  def self.find_reports(limit)
    Report.limit(limit)
  end

  def self.remove_transaction_id
    Report.update_all(transaction_id: "")
  end

  def self.parse_args
    options = { rps: 100, time: 10, file: "result", fake: false }
    opts = OptionParser.new
    opts.banner = "Usage: stress:apiroom [options]"
    opts.on("-r ARG", "--rps ARG", Integer, "Request per second") { |v| options[:rps] = v }
    opts.on("-t ARG", "--time ARG", Integer, "Total time to stress API") do |v|
      options[:time] = v
    end
    opts.on("-f", "--file FILE", String, "File name without extension to store data") do |v|
      options[:file] = v
    end
    opts.on("--fake [FLAG]", TrueClass, "Use fake data or not") do |v|
      options[:fake] = v.nil? ? true : v
    end
    opts.on("-h", "--help", "Show commands") do
      puts opts
      exit
    end
    args = opts.order!(ARGV) {}
    opts.parse!(args)
    options
  end

  def self.save_json(simple_test, file_name)
    json = JSON.pretty_generate(data_results(simple_test))
    File.open(file_name, "w") { |file| file.puts json }
  end

  def self.send_report(report)
    body = { data: { dataToStore: report.content_hash, reportID: report.id.to_s }, keys: {} }
    HTTParty.post(
      "#{ENV.fetch('ESTOOL_APIROOM_ENDPOINT') do
           'https://apiroom.net'
         end }/api/serveba/sawroom-write",
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
  end

  def self.ensure_file(file)
    path = "#{Rails.root}/results"
    Dir.mkdir(path) unless File.exist?(path)

    path << "/#{file}"
  end

  def self.data_results(test)
    data = {}
    data["summary"] = build_summary(test)
    data["request_per_second"] = build_data(test)
    data["errors"] = build_errors(test)
    data
  end

  def self.build_summary(test)
    summary = {}
    summary["min_time"] = test.summary_min_time.round(4)
    summary["max_time"] = test.summary_max_time.round(4)
    summary["avg_time"] = test.summary_avg_time.round(4)
    summary["total"] = test.summary_success + test.summary_error
    summary["success"] = test.summary_success
    summary["error"] = test.summary_error
    summary
  end

  def self.build_data(test)
    test.results.map do |_key, values|
      result = {}
      result["total"] = values.size
      result["success"] = values.count(&:pass)
      result["error"] = values.count { |val| !val.pass }
      avg = values.sum(&:time).fdiv(values.size) * 1000
      avg = 0 if avg.to_f.nan? || avg.infinite?
      result["avg_time"] = avg.round(4)
      result["max_time"] = (values.max_by(&:time).time * 1000).round(4)
      result["min_time"] = (values.min_by(&:time).time * 1000).round(4)
      result
    end
  end

  def self.build_errors(test)
    errors = test.results.collect do |_key, values|
      values.select do |node|
        node.pass == false
      end
    end.flatten
    errors = errors.group_by { |error| "#{error.error.class}: #{error.error.message}" }
    errors.transform_values(&:count)
  end
end

# This is the code from the lib but modified so we can access index of request
class GasLoadTestCustom
  attr_accessor :client, :time, :results

  DEFAULT = {
    client: 1000,
    time: 300
  }

  def initialize(args = {})
    args ||= {}
    args[:client] ||= args["client"]
    args[:time] ||= args["time"]
    args.reject! { |_key, value| value.nil? }
    args = DEFAULT.merge(args)

    self.client = args[:client]
    self.time = args[:time]
    self.results = {}
    @run = false
  end

  def run(args = {}, &block)
    args ||= {}
    args[:output] ||= args["output"]
    args[:file_name] ||= args["file_name"]
    args[:header] ||= args["header"]
    args[:description] ||= args["description"]
    puts "Running test (client: #{client}, time: #{time})"
    @progressbar = ProgressBar.create(
      title: "Load test",
      starting_at: 0,
      total: time + 10,
      format: "%a %b\u{15E7}%i %p%% %t",
      progress_mark: " ",
      remainder_mark: "\u{FF65}"
    )
    load_test(block)
    if args[:output]
      export_file({ file_name: args[:file_name], header: args[:header],
                    description: args[:description] })
    end
  ensure
    @run = true
  end

  def is_run?
    @run
  end

  def request_per_second
    client / time.to_f
  end

  def export_file(args = {})
    args ||= {}
    file = args[:file_name] || ""
    chart_builder = GasLoadTester::ChartBuilder.new(file_name: file, header: args[:header],
                                                    description: args[:description])
    chart_builder.build_body(self)
    chart_builder.save
  end

  def summary_min_time
    all_result_time.min * 1000
  end

  def summary_max_time
    all_result_time.max * 1000
  end

  def summary_avg_time
    avg = all_result_time.sum(0).fdiv(all_result_time.size) * 1000
    avg.to_f.nan? || avg.infinite? ? 0 : avg
  end

  def summary_success
    results.collect { |_key, values| values.count(&:pass) }.flatten.sum(0)
  end

  def summary_error
    results.collect { |_key, values| values.count { |val| !val.pass } }.flatten.sum(0)
  end

  private

  def all_result_time
    results.collect { |_key, values| values.collect(&:time) }.flatten
  end

  def load_test(block)
    threads = []
    rps = request_per_second
    rps_decimal = rps.modulo(1)
    full_rps = (rps - rps_decimal).to_i
    stacking_decimal = 0.0
    counter = 0
    time.times do |index|
      results[index] = []
      start_index_time = Time.now
      stacking_decimal += rps_decimal
      additional_client = 0
      if stacking_decimal > 1
        additional_client = 1
        stacking_decimal -= 1
      end
      if (index + 1) == time && (counter + (full_rps + additional_client)) < client
        additional_client += (client - (counter + (full_rps + additional_client)))
      end
      (full_rps + additional_client).times do |i|
        counter += 1
        threads << Thread.new do
          start_time = Time.now
          block.call(i + (index * (full_rps + additional_client)))
          results[index] << build_result({ pass: true, time: Time.now - start_time })
        rescue StandardError => e
          results[index] << build_result({ pass: false, error: e,
                                           time: Time.now - start_time })
        end
      end
      cal_sleep = 1 - (Time.now - start_index_time)
      cal_sleep = 0 if cal_sleep < 0
      sleep(cal_sleep)
      @progressbar.increment
    end
    ThreadsWait.all_waits(*threads)
    @progressbar.progress += 10
  end

  def build_result(args)
    GasLoadTester::Result.new(args)
  end
end
