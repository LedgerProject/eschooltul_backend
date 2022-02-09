FakeReport = Struct.new(:id, :content_hash)

namespace :stress do
  desc "Stress apiroom with lots of data"
  task :apiroom, %i[rps time] => :environment do
    args = parse_args

    rps = args[:rps].to_i
    puts "Using rps: #{rps}"
    time = args[:time].to_i
    puts "Using time: #{time}"
    file = ensure_file
    puts "Using filename: #{file}"

    puts "Stressing apiroom..."
    simple_test = GasLoadTester::Test.new({ client: rps * time, time: })
    simple_test.run(output: true, file_name: file) do
      send_report(FakeReport.new({
                                   content_hash: Digest::SHA256.hexdigest(SecureRandom.base64(24)),
                                   id: SecureRandom.uuid
                                 }))
    end
    # fix_result_table(file)
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
  options = { rps: 100, time: 10 }
  opts = OptionParser.new
  opts.banner = "Usage: stress:apiroom [options]"
  opts.on("-r ARG", "--rps ARG", Integer, "Request per second") { |v| options[:rps] = v }
  opts.on("-t ARG", "--time ARG", Integer, "Total time to stress API") { |v| options[:time] = v }
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
  Dir.mkdir(path) unless File.exists?(path)

  path << "/result_#{Time.now.to_i.to_s}.html"
end
