module RSpec
  module Matchers
    def allow_mass_assignment_of(*attributes)
      AllowMassAssignmentOfMatcher.new attributes
    end

    class AllowMassAssignmentOfMatcher
      def initialize(*attributes)
        @attributes = attributes[0]
      end

      def matches?(model)
        @model = model
        attributes_have_mass_assignability? true
      end

      def does_not_match?(model)
        @model = model
        attributes_have_mass_assignability? false
      end

      def failure_message_for_should
        "expected #{@model.inspect} to allow mass-assignment of #{@failed_attribute}"
      end

      def failure_message_for_should_not
        "expected #{@model.inspect} to respond to but not allow mass-assignment of #{@failed_attribute}"
      end

      def description
        "allow mass-assignment of #{@attributes}"
      end

      private

      def mass_assignable?(attribute)
        @model.class.accessible_attributes.include? attribute
      end

      def attributes_have_mass_assignability?(expected)
        @attributes.each do |attr|
          unless (expected || @model.respond_to?(attr)) &&
            mass_assignable?(attr) == expected
            @failed_attribute = attr
          end
        end

        @failed_attribute.nil?
      end
    end
  end
end

