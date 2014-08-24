module UndefinednessSupport

  attr_accessor :undefined

  def self.included(mod)
    mod.module_eval <<-EOS
      alias_method :_text_orig, :text
      def text
        if undefined
          "<UNDEFINED>"
        else
          _text_orig
        end
      end
    EOS
  end

end


class C
  attr_accessor :text

  include UndefinednessSupport
end



c=C.new
c.text="lalala"
p c.text
c.undefined = true
p c.text
c.undefined = false
p c.text
