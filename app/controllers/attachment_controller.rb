class AttachmentController < AuthenticatedController
  def destroy
    @document = ActiveStorage::Attachment.find(params[:id])
    @document.purge
    redirect_to request.referer
  end
end
