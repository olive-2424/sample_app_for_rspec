require 'rails_helper'

RSpec.describe Task, type: :model do

  describe "validation" do
    it "is valid with all attributes" do
      expect(build(:task)).to be_valid
    end
    it "is invalid without a title" do
      task_without_title = build(:task, title: nil)
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end
    it "is invalid without a status" do
      task_without_status = build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end
    it "is invalid with a duplicate title" do
      create(:task, title: "rspec_test")
      task_with_duplicated_title = build(:task, title: "rspec_test")
      expect(task_with_duplicated_title).to be_invalid
      expect(task_with_duplicated_title.errors[:title]).to include("has already been taken")
    end
    it "is valid with another title" do
      task1 = create(:task)
      task_with_another_title = build(:task)
      expect(task_with_another_title).to be_valid
    end
  end
end
