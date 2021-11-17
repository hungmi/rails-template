module ApplicationHelper
  def meta_title
    @page_title.present? ? '#{@page_title} | 鴻妍搏命' : '鴻妍搏命工作室'
  end

  def notice_message(opts = {})
    if flash.any?
      flash.map do |type, message|
        content_tag :div, class: "alert alert-#{type}", role:'alert' do
          content_tag :strong, type.capitalize
          message
        end
      end[0]
    end
  end

  def toasts(opts = {})
    if flash.any?
      capture do
        flash.map do |type, message|
          message_html = content_tag :div, class: "flash-message toast align-items-center bg-dark opacity-75 text-white border border-0 rounded-pill w-auto", role: "alert", aria: { live: 'assertive', atomic: true }, 'data-toast-target': 'toast', 'data-toaster-target': 'toast' do
            content_tag :div, class: "toast-body px-4 d-flex" do
              message.html_safe
            end
            # button_tag nil, type: 'button', class: "btn-close ms-auto me-2", data: { bs_dismiss: "toast" }, aria: { label: 'Close' }
          end
          concat message_html
        end
      end
    end
  end

  def not_desktop?
    browser = Browser.new(request.user_agent)
    browser.mobile? || browser.tablet?
  end
end
