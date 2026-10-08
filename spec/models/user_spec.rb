require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "名前・メールアドレス・パスワードがあれば有効" do
      expect(build(:user)).to be_valid
    end

    it "名前がないと無効" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to be_present
    end

    it "名前が12文字を超えると無効" do
      user = build(:user, name: "あ" * 13)
      expect(user).to be_invalid
      expect(user.errors[:name]).to be_present
    end

    it "名前が12文字ちょうどなら有効" do
      expect(build(:user, name: "あ" * 12)).to be_valid
    end
  end

  describe "個人グループの自動作成" do
    it "ユーザーを作成すると個人グループが1つ作られる" do
      expect { create(:user) }.to change(Group, :count).by(1)
    end

    it "作られたグループは個人グループとして扱われる" do
      user = create(:user)
      expect(user.groups.count).to eq(1)
      expect(user.groups.first).to be_is_personal
    end

    it "個人グループのオーナーは本人になる" do
      user = create(:user)
      expect(user.groups.first.owner).to eq(user)
    end

    it "個人グループには招待コードが入らない" do
      user = create(:user)
      expect(user.groups.first.invite_code).to be_nil
    end

    it "個人グループの名前はユーザー名になる" do
      user = create(:user, name: "山田太郎")
      expect(user.groups.first.name).to eq("山田太郎")
    end

    it "所属レコード（group_members）も同時に作られる" do
      expect { create(:user) }.to change(GroupMember, :count).by(1)
    end

    it "作成直後からユーザーは必ず1つ以上のグループに所属している" do
      user = create(:user)
      expect(user.groups).to be_present
    end

    it "個人グループの作成に失敗した場合はユーザーも作成されない" do
      # create! にしていることで、失敗が握りつぶされずロールバックされる
      allow_any_instance_of(Group).to receive(:valid?).and_return(false)

      expect {
        expect { create(:user) }.to raise_error(ActiveRecord::RecordInvalid)
      }.not_to change(User, :count)
    end
  end

  describe "関連" do
    it "所属しているグループを取得できる" do
      user = create(:user)
      joined = create(:group)
      create(:group_member, user: user, group: joined)

      # 個人グループ + 参加したグループ
      expect(user.groups).to include(joined)
      expect(user.groups.count).to eq(2)
    end

    it "オーナーになっているグループを取得できる" do
      user = create(:user)
      owned = create(:group, owner: user)

      # 個人グループも本人がオーナーなので2件になる
      expect(user.owned_groups).to include(owned)
      expect(user.owned_groups.count).to eq(2)
    end

    # 現状の仕様を固定するためのテスト。
    # 個人グループが groups.owner_id で本人を参照しており、owned_groups に
    # dependent: を付けていないため、外部キー制約でユーザーを削除できない。
    # 退会機能を作るときに所有グループの扱い（移譲 or 削除）とあわせて見直す
    it "オーナーとしてグループを持っているため、現状ユーザーは削除できない" do
      user = create(:user)
      expect { user.destroy }.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end
end
