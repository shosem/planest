# 開発用のデータなので、誤って本番で流さないようにガードする
unless Rails.env.development?
    puts "seed は development 環境でのみ実行できます"
    return
end

# ステータスを順番に割り当てるために使う。
# rand にすると実行のたびに変わり、チーム内で画面が揃わないので固定する
statuses = %i[todo in_progress done]

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

    # 検索キーは user / group / title だけにする。
    # description や status を引数に混ぜると検索条件に含まれてしまい、
    # 値が変わったときに同じタスクが二重に作られる
    Task.find_or_create_by!(user: user, group: group, title: "#{user.name}タスク#{n}") do |task|
      task.description = "テストタスク#{n}"
      task.status      = statuses[n - 1]
    end
  end

  # 個人グループにもタスクを置く（個人タスクの日報がこのアプリの中心機能のため）
  personal = user.personal_group
  (1..3).each do |n|
    Task.find_or_create_by!(user: user, group: personal, title: "#{user.name}の個人タスク#{n}") do |task|
      task.description = "個人タスク#{n}"
      task.status      = statuses[n - 1]
    end
  end
end

# 全員が参加している共有グループを1つ作る（サイドバーの見え方の確認用）
shared = users.first.owned_groups.find_or_create_by!(name: "全体共有")
users.each { |user| shared.group_members.find_or_create_by!(user: user) }

# 担当者がばらけたタスクを置く（一覧での担当者表示の確認用）。
# Task の user_must_be_group_member を通すため、必ず group_members 作成後に実行する
users.each_with_index do |user, i|
  Task.find_or_create_by!(user: user, group: shared, title: "全体共有タスク#{i + 1}") do |task|
    task.description = "#{user.name}が担当"
    task.status      = statuses[i % 3]
  end
end

puts "ユーザー      : #{User.count}"
puts "個人グループ  : #{Group.where(is_personal: true).count}"
puts "通常グループ  : #{Group.where(is_personal: false).count}"
puts "所属レコード  : #{GroupMember.count}"
puts "タスク        : #{Task.count}"
