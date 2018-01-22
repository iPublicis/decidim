# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe UnsubscribeSettings do
    describe "call" do
      let(:organization) { create(:organization) }
      let(:command) { described_class.new(user) }

      context "when invalid" do
        let(:user) { create(:user, organization: organization, newsletter_notifications: "0") }

        it "Doesn't unsubscribe user" do
          expect { command.call }.to broadcast(:invalid)
        end
      end

      context "when valid" do
        let(:user) { create(:user, organization: organization, newsletter_notifications: "1") }

        it "unsubscribes user" do
          user.newsletter_notifications = "0"
          user.save!
        end

        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end
      end
    end
  end
end