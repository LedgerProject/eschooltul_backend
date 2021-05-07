module StudentsHelper
  def download_link_icon(filename)
    extname = File.extname(filename.to_s)

    return "doc.png" if [".doc", ".docx"].include?(extname)

    "pdf.png"
  end
end
