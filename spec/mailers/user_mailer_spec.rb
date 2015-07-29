require "spec_helper"

describe UserMailer do
  describe "return_reminder" do
    user = User.create(name: "John", email: "john@gmail.com", password: "password")
    let(:mail) { UserMailer.return_reminder(user) }

    it "renders the headers" do
      mail.subject.should eq("Reservation Reminder")
      mail.to.should eq(["john@gmail.com"])
      mail.from.should eq(["calteach_peers@berkeley.edu"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
