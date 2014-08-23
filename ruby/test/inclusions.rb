module WebConfig
  XMLS_PATH="/home/olaf/isst-backup/olaf/wind/providerxmls/providerxmls-ui/provider-xmls/"
end


module EditorHelper
#  def self.append_features(controller) #:nodoc:
#    controller.ancestors.include?(ActionController::Base) ? controller.add_template_helper(self) : super
#  end


  ###QU: ohne diese Zeile geht's nicht (s.u.). Warum nicht?...
  include WebConfig

  def xmls
    result=Object.new
    def result.each
      Dir.foreach(XMLS_PATH) {|name| yield(name) if (name =~ /.xml$/); }
    end
    result.extend(Enumerable)
    result
  end

  def bla
    @bla
  end
end



class EditorController
  ###...denn eigentlich wird WebConfig ja hier included
  include WebConfig
  include EditorHelper


  def info
    xmls.each do |xml|
      print ">>#{xml}\n"
    end
  end

end




EditorController.new.info
