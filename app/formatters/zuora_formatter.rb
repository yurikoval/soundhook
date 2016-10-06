class ZuoraFormatter < BaseFormatter
  def data
    {
      type: :sale,
      sound_url: @webhook.sound_file.url,
      format: @webhook.sound_file_content_type,
      amount: params_from_xml[:PaymentAmount],
      country: params_from_xml[:SoldToContactCountry],
      city: params_from_xml[:PaymentMethodCity],
    }
  end

  def params_from_xml
    @params_from_xml ||= begin
      xml = @request.body.read
      xml_root = Nokogiri::XML(xml).children.detect { |child| child.name == "callout" }.children
      xml_root.each_with_object({}) do |param, hash|
        key = param.attributes["name"].try(:value)
        if key
          value = param.children.first.to_s
          hash[key.to_sym] = value
        end
      end
    end
  end
end
