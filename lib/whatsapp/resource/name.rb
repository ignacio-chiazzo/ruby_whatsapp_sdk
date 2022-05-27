module Whatsapp
  module Resource
    class Name
      attr_accessor :formatted_name, :first_name, :last_name, :middle_name, :suffix, :prefix
      
      def initialize(
        formatted_name: nil, first_name: nil,
        last_name: nil, middle_name: nil, suffix: nil, prefix: nil
      )
        @formatted_name = formatted_name
        @first_name = first_name
        @last_name = last_name
        @middle_name = middle_name
        @suffix = suffix
        @prefix = prefix
      end

      def to_h
        {
          formatted_name:  @formatted_name,
          first_name:      @first_name,
          last_name:       @last_name,
          middle_name:     @middle_name,
          suffix:          @suffix,
          prefix:          @prefix 
        }
      end
    end
  end
end
