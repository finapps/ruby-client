module ObjectExtensions
  refine Object do
    def integer?
      Integer(self)
    rescue
      false
    else
      true
    end
  end
end
