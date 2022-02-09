FakeReport = Struct.new(:id, :content_hash)

namespace :stress do
  desc "Stress apiroom with lots of data"
  task :apiroom, %i[rps time file] => :environment do
    args = parse_args

    rps = args[:rps].to_i
    puts "Using rps: #{rps}"
    time = args[:time].to_i
    puts "Using time: #{time}"

    if args[:file]
      file = ensure_file
      puts "Using filename: #{file}"
    end

    puts "Stressing apiroom..."
    simple_test = GasLoadTester::Test.new({ client: rps * time, time: })
    simple_test.run(output: args[:file], file_name: file) do
      send_report(FakeReport.new({
                                   content_hash: Digest::SHA256.hexdigest(SecureRandom.base64(24)),
                                   id: SecureRandom.uuid
                                 }))
    end

    puts JSON.pretty_generate(data_results(simple_test)) unless args[:file]
    fix_result_table(file) if args[:file]
    exit
  end
end

def fix_result_table(file_name)
  text = File.read(file_name)
  new_contents = text.gsub(/&lt;/, "<")
  new_contents = new_contents.gsub(/&quot;/, "\"")
  new_contents = new_contents.gsub(/&gt;/, ">")

  File.open(file_name, "w") { |file| file.puts new_contents }
end

def parse_args
  options = { rps: 100, time: 10, file: false }
  opts = OptionParser.new
  opts.banner = "Usage: stress:apiroom [options]"
  opts.on("-r ARG", "--rps ARG", Integer, "Request per second") { |v| options[:rps] = v }
  opts.on("-t ARG", "--time ARG", Integer, "Total time to stress API") { |v| options[:time] = v }
  opts.on("-f", "--file [FLAG]", TrueClass, "Store in file or not") do |v|
    options[:file] = v.nil? ? true : v
  end
  opts.on("-h", "--help", "Show commands") do
    puts opts
    exit
  end
  args = opts.order!(ARGV) {}
  opts.parse!(args)
  options
end

def send_report(report)
  body = { data: { dataToStore: report.content_hash, reportID: report.id }, keys: {} }
  HTTParty.post(
    "#{ENV.fetch('ESTOOL_APIROOM_ENDPOINT') { 'https://apiroom.net' }}/api/serveba/sawroom-write",
    body: body.to_json,
    headers: { "Content-Type" => "application/json" }
  )
end

def ensure_file
  path = "#{Rails.root}/results"
  Dir.mkdir(path) unless File.exist?(path)

  path << "/result_#{Time.now.to_i}.html"
end

def data_results(test)
  data = {}
  data["summary"] = build_summary(test)
  data["request_per_second"] = build_data(test)
  data["errors"] = build_errors(test)
  data
end

def build_summary(test)
  summary = {}
  summary["min_time"] = test.summary_min_time.round(4)
  summary["max_time"] = test.summary_max_time.round(4)
  summary["avg_time"] = test.summary_avg_time.round(4)
  summary["total"] = test.summary_success + test.summary_error
  summary["success"] = test.summary_success
  summary["error"] = test.summary_error
  summary
end

def build_data(test)
  test.results.map do |key, values|
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

def build_errors(test)
  errors = test.results.collect do |_key, values|
    values.select do |node|
      node.pass == false
    end
  end.flatten
  errors = errors.group_by { |error| "#{error.error.class}: #{error.error.message}" }
  errors.transform_values(&:count)
end
