require 'rails_helper'

RSpec.describe List, type: :model do
  describe '#complete_all_tasks!' do
    it 'should mark all tasks from the list as complete' do 
      list = List.create(name: "Groceries")
      Task.create(complete: false, list_id: list.id, name: "Sour Cream")
      Task.create(complete: false, list_id: list.id, name: "Sour Milk")

      list.complete_all_tasks!

      list.tasks.each do |task|
        expect(task.complete).to eq(true)
      end
    end
  end
end
