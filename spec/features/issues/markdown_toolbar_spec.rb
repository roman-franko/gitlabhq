require 'rails_helper'

feature 'Issue markdown toolbar', feature: true, js: true do
  let(:project) { create(:project, :public) }
  let(:issue)   { create(:issue, project: project) }
  let(:user)   { create(:user) }

  before do
    login_as(user)

    visit namespace_project_issue_path(project.namespace, project, issue)
  end

  it "doesn't include first new line when adding bold" do
    find('#note_note').native.send_keys('test')
    find('#note_note').native.send_key(:enter)
    find('#note_note').native.send_keys('bold')

    page.evaluate_script('document.getElementById("note_note").setSelectionRange(4, 9)')

    first('.toolbar-btn').click

    expect(find('#note_note')[:value]).to eq("test\n**bold**\n")
  end

  it "doesn't include first new line when adding underline" do
    find('#note_note').native.send_keys('test')
    find('#note_note').native.send_key(:enter)
    find('#note_note').native.send_keys('underline')

    page.evaluate_script('document.getElementById("note_note").setSelectionRange(4, 50)')

    find('.toolbar-btn:nth-child(2)').click

    expect(find('#note_note')[:value]).to eq("test\n*underline*\n")
  end
end
