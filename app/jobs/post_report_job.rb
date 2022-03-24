class PostReportJob < ApplicationJob
  queue_as :default

  def perform(user_id, post_id)
    user = User.find(user_id)
    post = Post.find(post_id)
    report = PostReport.generate(post)
    # Do something later
    # un usuario nos pedira el reporte de un post, y le enviaremos un correo con este reporte
    PostReportMailer.post_report(user, post, report).deliver_now
  end
end
