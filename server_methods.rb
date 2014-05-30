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
  query = "INSERT INTO articles (title, url, user_id,description, score, created_at)
            VALUES ($1,$2,$3,$4,0, NOW());"
  article = db_connection do |conn|
    conn.exec_params(query,[title, url, user_id, description])
  end
end

def new_user(user_name, password, email = nil)

  query = "SELECT user_name
            FROM users
            WHERE user_name LIKE $1;"

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
    return 1
  else
    return 0
  end
end

def login(user_name, password)
  query = "SELECT user_name, password, id
            FROM users
            WHERE user_name LIKE $1
                AND password LIKE $2"
  check = db_connection do |conn|
    conn.exec_params(query, [user_name,password])
  end
  check = check.to_a
  # no results => username and password do not match
  if check.length == 0
    return nil, 0
  #user name and password exist
  else
    user_id = check[0]["id"]
    success = 1
    return user_id, success
  end
end

