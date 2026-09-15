require "rails_helper"

RSpec.describe Group, type: :model do
  describe "バリデーション" do
    it "名前とオーナーがあれば有効" do
      expect(build(:group)).to be_valid
    end

    it "名前がないと無効" do
      group = build(:group, name: nil)
      expect(group).to be_invalid
      expect(group.errors[:name]).to be_present
    end

    it "オーナーがないと無効" do
      group = build(:group, owner: nil)
      expect(group).to be_invalid
      expect(group.errors[:owner]).to be_present
    end
  end

  describe "招待コードの自動生成" do
    it "通常グループを作成すると招待コードが自動生成される" do
      group = create(:group)
      expect(group.invite_code).to be_present
      expect(group.invite_code.length).to eq(10)
    end

    it "グループごとに異なる招待コードが生成される" do
      codes = create_list(:group, 3).map(&:invite_code)
      expect(codes.uniq.size).to eq(3)
    end

    it "個人グループには招待コードが生成されない" do
      personal = create(:user).groups.find_by(is_personal: true)
      expect(personal.invite_code).to be_nil
    end

    it "招待コードを指定して作成しても、サーバー側で生成した値で上書きされる" do
      group = create(:group, invite_code: "MYOWNCODE1")
      expect(group.invite_code).not_to eq("MYOWNCODE1")
    end
  end

  describe "招待コードのバリデーション" do
    it "通常グループの招待コードを空にすると無効" do
      group = create(:group)
      group.invite_code = nil
      expect(group).to be_invalid
      expect(group.errors[:invite_code]).to be_present
    end

    it "個人グループに招待コードを入れると無効" do
      personal = create(:user).groups.find_by(is_personal: true)
      personal.invite_code = "ABC1234567"
      expect(personal).to be_invalid
      expect(personal.errors[:invite_code]).to be_present
    end

    it "他のグループと同じ招待コードは無効" do
      existing = create(:group)
      other = create(:group)
      # 作成時のみ自動生成されるので、更新なら任意の値を入れられる
      other.invite_code = existing.invite_code
      expect(other).to be_invalid
      expect(other.errors[:invite_code]).to be_present
    end
  end

  describe "DB制約（バリデーションを迂回しても守られること）" do
    it "オーナーのいない行は作れない" do
      group = create(:group)
      expect {
        group.update_column(:owner_id, nil)
      }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "個人グループが招待コードを持つ行は作れない" do
      personal = create(:user).groups.find_by(is_personal: true)
      expect {
        personal.update_column(:invite_code, "ABC1234567")
      }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "通常グループの招待コードが空の行は作れない" do
      group = create(:group)
      expect {
        group.update_column(:invite_code, nil)
      }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "招待コードは重複できない" do
      existing = create(:group)
      other = create(:group)
      expect {
        other.update_column(:invite_code, existing.invite_code)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "1ユーザーにつき個人グループは1つまでしか作れない" do
      user = create(:user) # コールバックで個人グループが1つ作られている
      expect {
        user.groups.create!(name: "2つめの個人グループ", owner: user, is_personal: true)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "関連" do
    it "所属しているユーザーを取得できる" do
      group = create(:group)
      member1 = create(:user)
      member2 = create(:user)
      create(:group_member, group: group, user: member1)
      create(:group_member, group: group, user: member2)

      expect(group.users).to contain_exactly(member1, member2)
    end

    it "グループを削除すると所属レコードも削除される" do
      group = create(:group)
      create(:group_member, group: group, user: create(:user))

      expect { group.destroy }.to change(GroupMember, :count).by(-1)
    end
  end
end
