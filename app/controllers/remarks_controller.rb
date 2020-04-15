class RemarksController < ApplicationController
  def create
    @remark = Remark.new(remark_params)

    if @remark.save
      transaction_notice = "De opmerking werk correct toegevoegd."
      redirect_to artwork_id_path(@remark.artwork.id), notice: transaction_notice
    else
      flash[:error] = "De opmerking kon niet geplaatst worden."
      redirect_to artwork_id_path(@remark.artwork.id)
    end
  end

  def remark_params
    params.require(:remark).permit(:body, :artwork_id)
  end
end
