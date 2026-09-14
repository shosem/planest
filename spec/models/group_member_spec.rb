require "rails_helper"

RSpec.describe GroupMember, type: :model do
  describe "バリデーション" do
    it "ユーザーとグループがあれば有効" do
      expect(build(:group_member)).to be_valid
    end

    it "ユーザーがないと無効" do
      member = build(:group_member, user: nil)
      expect(member).to be_invalid
      expect(member.errors[:user]).to be_present
    end

    it "グループがないと無効" do
      member = build(:group_member, group: nil)
      expect(member).to be_invalid
      expect(member.errors[:group]).to be_present
    end
  end

  describe "二重所属の防止" do
    it "同じユーザーが同じグループに2回所属することはできない" do
      user = create(:user)
      group = create(:group)
      create(:group_member, user: user, group: group)

      duplicate = build(:group_member, user: user, group: group)
      expect(duplicate).to be_invalid
      expect(duplicate.errors[:user_id]).to be_present
    end

    it "同じユーザーでも別のグループには所属できる" do
      user = create(:user)
      create(:group_member, user: user, group: create(:group))

      expect(build(:group_member, user: user, group: create(:group))).to be_valid
    end

    it "同じグループに別のユーザーは所属できる" do
      group = create(:group)
      create(:group_member, user: create(:user), group: group)

      expect(build(:group_member, user: create(:user), group: group)).to be_valid
    end

    it "バリデーションを迂回してもDBが二重所属を拒否する" do
      user = create(:user)
      group = create(:group)
      create(:group_member, user: user, group: group)

      expect {
        GroupMember.insert!({ user_id: user.id, group_id: group.id,
                              created_at: Time.current, updated_at: Time.current })
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
