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

  def toast_message(opts = {})
    if flash.any?
      flash.map do |type, message|
        content_tag :div, class: "toast d-flex align-items-center text-white bg-#{type} border-0", style: 'position: fixed; left: 3.5vw; bottom: 3.5vw; z-index: 9999;', role: "alert", aria: { live: 'assertive', atomic: true }, data: { controller: 'toast' } do
          content_tag :div, class: "toast-body" do
            message
          end
          # button_tag nil, type: 'button', class: "btn-close ms-auto me-2", data: { bs_dismiss: "toast" }, aria: { label: 'Close' }
        end
      end[0]
    end
  end

  def not_desktop?
    browser = Browser.new(request.user_agent)
    browser.mobile? || browser.tablet?
  end
end
