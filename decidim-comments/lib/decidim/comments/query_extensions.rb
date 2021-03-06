# frozen_string_literal: true

module Decidim
  module Comments
    # This module's job is to extend the API with custom fields related to
    # decidim-comments.
    module QueryExtensions
      # Public: Extends a type with `decidim-comments`'s fields.
      #
      # type - A GraphQL::BaseType to extend.
      #
      # Returns nothing.
      def self.define(type)
        type.field :commentable do
          type !CommentableType

          argument :id, !types.String, "The commentable's ID"
          argument :type, !types.String, "The commentable's class name. i.e. `Decidim::ParticipatoryProcess`"
          argument :locale, !types.String, "The locale for which to get the comments text"
          argument :toggleTranslations, !types.Boolean, "Whether the user asked to toggle the machine translations or not."

          resolve lambda { |_obj, args, _ctx|
            I18n.locale = args[:locale].presence
            RequestStore.store[:toggle_machine_translations] = args[:toggleTranslations]
            args[:type].constantize.find(args[:id])
          }
        end
      end
    end
  end
end
