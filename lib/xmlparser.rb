require 'rexml/parsers/pullparser'
require 'htmlentities'

class String
  # Truncate strings containing HTML code
  # Usage example: "string".truncate_html(50, :word_cut => false, :tail => '[+]')
  def truncate_html(len = 30, opts = {})
    opts = {:word_cut => false, :tail => ' ...'}.merge(opts)
    p = REXML::Parsers::PullParser.new(self)
    tags = []
    new_len = len
    results = ''
    while p.has_next? && new_len > 0
      p_e = p.pull
      case p_e.event_type
      when :start_element
        tags.push p_e[0]
        results << "<#{tags.last} #{attrs_to_s(p_e[1])}>"
      when :end_element
        results << "</#{tags.pop}>"
      when :text
        text = HTMLEntities.decode_entities(p_e[0])
        if (text.length > new_len) and !opts[:word_cut]
          piece = text.first(text.index(' ', new_len))
        else
          piece = text.first(new_len)
        end
        results << HTMLEntities.encode_entities(piece)
        new_len -= text.length
      else
        results << "<!-- #{p_e.inspect} -->"
      end
    end
    tags.reverse.each do |tag|
      results << "</#{tag}>"
    end
    results << opts[:tail]
  end

  private

  def attrs_to_s(attrs)
    if attrs.empty?
      ''
    else
      attrs.to_a.map { |attr| %{#{attr[0]}="#{attr[1]}"} }.join(' ')
    end
  end
end