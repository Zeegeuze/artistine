# frozen_string_literal: true

ActiveAdmin.register AnswerRemark do
  menu false

  actions :create, :destroy

  permit_params :body, :admin_user_id, :remark_id

  scope_to :current_admin_user
  
  controller do
    def create
      @answer_remark = current_admin_user.answer_remarks.new(permitted_params[:answer_remark])
      @answer_remark.admin_user = current_admin_user
      @answer_remark.remark_id = params[:answer_remark][:remark_id]

      if @answer_remark.save
        transaction_notice = "De opmerking werd correct geplaatst"
        redirect_to admin_remarks_path, notice: transaction_notice
      else
        transaction_alert = "Gelieve een opmerking in te vullen"
        redirect_to admin_remarks_path, alert: transaction_alert
      end
    end

    def destroy
      @answer_remark = AnswerRemark.find(params[:id])
      if @answer_remark.destroy
        redirect_to admin_remarks_path, notice: "Antwoord werd verwijderd." 
      else
        return redirect_to admin_remarks_path, alert: @answer_remark.errors.full_messages.to_sentence
      end
    end
  end
end