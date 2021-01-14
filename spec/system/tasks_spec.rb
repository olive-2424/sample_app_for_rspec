require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe 'タスクリソースへの遷移確認' do
      context 'タスクの一覧ページにアクセス' do
        it 'タスクの一覧ページが表示される' do
          task_list = create_list(:task, 3)
          visit root_path
          expect(current_path).to eq root_path
          expect(page).to have_content task_list[0].title
          expect(page).to have_content task_list[1].title
          expect(page).to have_content task_list[2].title
        end
      end

      context 'タスクの詳細ページにアクセス' do
        it 'タスクの詳細ページが表示される' do
          visit task_path(task)
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タスクの新規作成ページにアクセス' do
        it '新規作成ページへのアクセスが失敗する' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end

      context 'タスクの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_task_path(task)
          expect(current_path).to eq login_path
          expect(page).to have_content('Login required')
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }

    describe 'タスク新規登録' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'rspec_title'
          fill_in 'Content', with: 'rspec_content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2021, 1, 13, 11, 10)
          click_button 'Create Task'
          expect(current_path).to eq '/tasks/1'
          expect(page).to have_content 'Title: rspec_title'
          expect(page).to have_content 'Content: rspec_content'
          expect(page).to have_content 'Status: todo'
          expect(page).to have_content 'Deadline: 2021/1/13 11:10'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: nil
          fill_in 'Content', with: 'rspec_content'
          click_button 'Create Task'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          other_task = create(:task)
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'rspec_content'
          click_button 'Create Task'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end

    describe 'タスクの編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'title_update'
          fill_in 'Content', with: 'content_update'
          select 'doing', from: 'Status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content 'title_update'
          expect(page).to have_content 'content_update'
          expect(page).to have_content 'doing'
          expect(page).to have_content 'Task was successfully updated.'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: nil
          select 'doing', from: 'Status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
        end
      end

      context '登録済みのタイトルを使用' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: other_task.title
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }

      context 'Destroyリンクをクリック' do
        it 'タスクの削除が成功する' do
          visit tasks_path
          click_link 'Destroy'
          expect(page.accept_confirm).to eq 'Are you sure?'
          expect(current_path).to eq tasks_path
          expect(page).to have_content 'Task was successfully destroyed'
          expect(page).not_to have_content task.title
        end
      end
    end
  end
end
