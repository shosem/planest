FactoryBot.define do
  factory :user do
    # メールアドレスは unique 制約があるので、連番でぶつからないようにする
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    # name は 12文字以内のバリデーションがあるので短めにする
    sequence(:name) { |n| "テスト#{n}" }
  end
end
