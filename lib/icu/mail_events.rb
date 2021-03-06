module ICU
  class MailEvents
    def save(print=false)
      date = ::Date.today.yesterday
      data = ::Util::Mailgun.events(date)
      if print
        puts data.inspect
      else
        event = ::MailEvent.where(date: date).first
        if event
          ::MailEvent::CODES.keys.each { |atr| data[atr.to_s] = 0 unless data.has_key?(atr.to_s) }
          data.each { |atr,val| event.send("#{atr}=", val) }
          event.save! if event.changed?
        else
          data["date"] = date
          ::MailEvent.create!(data)
        end
      end
    rescue => e
      if print
        puts "ERROR: #{e.class}, #{e.message}\n#{e.backtrace[0..3].join("\n")}"
      else
        ::Failure.log("MailEventsReport", exception: e, date: date.to_s)
      end
    end
  end
end
