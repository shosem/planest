  # 開発用のデータなので、誤って本番で流さないようにガードする
  unless Rails.env.development?
    puts "seed は development 環境でのみ実行できます"
    return
  end

  # find_or_create_by! で冪等にする（何度実行してもデータが増えない）
  # ユーザー作成時に after_create が個人グループを自動で作るので、
  # 個人グループはここでは作らない
  users = [
    { name: "しょせ", email: "shose@example.com" },
    { name: "とま",   email: "toma@example.com" },
    { name: "かん",   email: "kan@example.com" },
    { name: "ひー",   email: "hi@example.com" }
  ].map do |attrs|
    User.find_or_create_by!(email: attrs[:email]) do |user|
      user.name     = attrs[:name]
      user.password = "password"
    end
  end

  # 各ユーザーが3件ずつ通常グループを所有し、そこに所属している状態を作る
  users.each do |user|
    (1..3).each do |n|
      # owned_groups 経由にすると owner_id が自動で入り、
      # 検索もそのユーザーの所有グループに絞られる
      group = user.owned_groups.find_or_create_by!(name: "#{user.name}のグループ#{n}")

      # 所有と所属は別なので、group_members は明示的に作る
      group.group_members.find_or_create_by!(user: user)
    end
  end

  # 全員が参加している共有グループを1つ作る（サイドバーの見え方の確認用）
  shared = users.first.owned_groups.find_or_create_by!(name: "全体共有")
  users.each { |user| shared.group_members.find_or_create_by!(user: user) }

  puts "ユーザー      : #{User.count}"
  puts "個人グループ  : #{Group.where(is_personal: true).count}"
  puts "通常グループ  : #{Group.where(is_personal: false).count}"
  puts "所属レコード  : #{GroupMember.count}"
