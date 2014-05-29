require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')

    yield(connection)

  ensure
    connection.close
  end
end

def get_articles()
  query = " SELECT articles.id as article_id, title, url, description, score, user_name
            FROM articles
            JOIN users on articles.user_id = users.id;"

  articles = db_connection do |conn|
    conn.exec(query)
  end

  articles = articles.to_a
  return articles
end

def new_article(title, url, description, user_id)
  query = "INSERT INTO articles (title, url, description, user_id, score)
            VALUES ($1,$2,$3,$4,0);"
  article = db_connection do |conn|
    conn.exec_params(query,[title, url, description, user_id])
  end

end

def new_user(user_name, password, email = nil)

  query = "SELECT user_name
            FROM users
            WHERE user_name LIKE '$1';"

  check = db_connection do |conn|
    conn.exec_params(query,[user_name])
  end
  check = check.to_a
  if check.length == 0
    # creates the new user
    query = "INSERT INTO users (user_name, password, email)
              VALUES ($1,$2,$3);"
    user = db_connection do |conn|
      conn.exec_params(query, [user_name,password,email])
    end
    return true
  else
    return false
  end
end
