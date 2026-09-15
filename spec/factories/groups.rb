FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "グループ#{n}" }
    association :owner, factory: :user
    is_personal { false }

    # 個人グループはユーザー作成時のコールバックで自動的に作られる。
    # DB に「1ユーザーにつき個人グループは1つ」の制約があるため、
    # このトレイトは build 専用（create すると制約違反になる）
    trait :personal do
      is_personal { true }
    end
  end
end
