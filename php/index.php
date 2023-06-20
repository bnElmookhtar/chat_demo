<?php 


try {

  $db = new Database();

  $q = $_POST["q"];

  if ($q == "login") {
    $phone = $_POST["phone"];

    if (!ctype_digit($phone) || strlen($phone) != 11 || substr($phone, 0, 2) != "01") 
      error("Invalid or not a phone number");

    $results = $db->run(sprintf("
       SELECT *
       FROM user 
       WHERE phone = '%s'
     ", $_POST["phone"]));

    if (count($results) == 0) 
      error("Not registered yet");

    done($results);
  }

  if ($q == "register") {
    $phone = $_POST["phone"];
    $name = $_POST["name"];

    if (!ctype_digit($phone) || strlen($phone) != 11 || substr($phone, 0, 2) != "01") 
      error("Invalid or not a phone number");

    $results = $db->run(sprintf("
      SELECT id 
      FROM user 
      WHERE phone = '%s'
    ", $_POST["phone"]));

    if (count($results) != 0) 
      error("This phone is already registered");

    if (strlen($name) > 30 || strlen($name) < 2) 
      error("Empty name field or not in range 2..30 letters");

    $results = $db->run(sprintf("
      INSERT INTO user (phone, name) 
      VALUES ('%s', '%s')
    ", $_POST["phone"], $_POST["name"]));

    $results = $db->run(sprintf("
      SELECT *
      FROM user 
      WHERE phone = '%s'
    ", $_POST["phone"]));

    done($results);
  }

  if ($q == "get_chats") {
    $p = $_POST["p"];
    $userId = $_POST["user_id"];

    if ($p == "broadcast") {
      $results = $db->run(sprintf("      
        SELECT b.id, m.text, m.timestamp, u.name
        FROM broadcast AS b
        LEFT JOIN sends_broadcast AS sb
          ON sb.message_id = (
            SELECT MAX(sb2.message_id)
            FROM sends_broadcast AS sb2
            WHERE sb2.broadcast_id = b.id
          )
        LEFT JOIN message as m 
          ON m.id = sb.message_id
        JOIN user as u 
          ON u.id IN (
            SELECT rb.receiver_id 
            FROM receives_broadcast as rb
            WHERE rb.broadcast_id = b.id
          )
        WHERE b.sender_id = %s
        ORDER BY m.id DESC, b.id, u.name
      ", $userId));

      done($results);
    } 

    if ($p == "person") {
      $results = $db->run(sprintf("      
        SELECT u.id, u.name, m.text, m.timestamp, sender_id=%s AS is_sender
        FROM user AS u 
        JOIN sends_user AS su1 
          ON su1.message_id = (
             SELECT MAX(su2.message_id)
             FROM sends_user AS su2
             WHERE su2.receiver_id = u.id AND su2.sender_id = %s
             OR su2.receiver_id = %s AND su2.sender_id = u.id
          )
        JOIN message AS m
          ON m.id = su1.message_id
        WHERE 
          %s = ANY(
            SELECT su3.sender_id
            FROM sends_user AS su3
            WHERE su3.receiver_id = u.id
            UNION
            SELECT su3.receiver_id
            FROM sends_user AS su3
            WHERE su3.sender_id = u.id
          )
        GROUP BY u.id
        ORDER BY m.id DESC, u.id
      ", $userId, $userId, $userId, $userId));

      done($results);
    } 

    if ($p == "group") {
      $results = $db->run(sprintf("      
        SELECT g.id, g.name, m.text, m.timestamp, u.name AS sender_name, u.id = jg.user_id AS is_sender
        FROM joins_group AS jg
        JOIN `group` AS g
          ON g.id = jg.group_id
        LEFT JOIN sends_group AS sg1
          ON sg1.group_id = g.id
          AND sg1.message_id = (
              SELECT MAX(sg2.message_id)
              FROM sends_group AS sg2
              WHERE sg2.group_id = g.id
          )
        LEFT JOIN message AS m 
          ON m.id = sg1.message_id
        LEFT JOIN user AS u 
          ON u.id = sg1.sender_id
        WHERE jg.user_id = %s
        ORDER BY m.id DESC, g.id
      ", $userId));

      done($results);
    }
  }

 if ($q == "get_messages") {
    $p = $_POST["p"];
    $userId = $_POST["user_id"];
    $selectedId = $_POST["selected_id"];

    if ($p == "broadcast") {
      $results = $db->run(sprintf("      
        SELECT m.id, m.text, m.timestamp, 1 AS is_sender
        FROM sends_broadcast AS sb
        JOIN message AS m 
          ON m.id = sb.message_id
        WHERE sb.broadcast_id = %s
        ORDER BY m.id;
      ", $selectedId));

      done($results);
    } 

    if ($p == "person") {
      $results = $db->run(sprintf("      
        SELECT m.id, m.text, m.timestamp, su.sender_id = %s AS is_sender
        FROM sends_user AS su 
        JOIN message AS m 
          ON m.id = su.message_id
        WHERE su.receiver_id = %s AND su.sender_id = %s
          OR su.sender_id = %s  AND su.receiver_id = %s;
      ", $userId, $selectedId, $userId, $selectedId, $userId));

      done($results);
    } 

    if ($p == "group") {
      $results = $db->run(sprintf("      
        SELECT m.id, m.text, m.timestamp, u.id AS sender_id, u.name AS sender_name, u.id = %s AS is_sender
        FROM sends_group AS sg 
        JOIN user AS u 
          ON u.id = sg.sender_id
        JOIN message AS m 
          ON m.id = sg.message_id
        WHERE sg.group_id = %s
        ORDER BY m.id;
      ", $userId, $selectedId));

      done($results);
    }
  }

  if ($q == "send_message") {

    $p = $_POST["p"];
    $userId = $_POST["user_id"];
    $selectedId = $_POST["selected_id"];
    $text = $_POST["text"];

    if ($p == "broadcast") {
      $results = $db->run(sprintf("      
        INSERT INTO message(text) VALUES ('%s');
        INSERT INTO sends_broadcast VALUES (%s, LAST_INSERT_ID());
        INSERT INTO sends_user (
          SELECT u.id, %s, (
            SELECT MAX(m.id)
            FROM message AS m
          )
          FROM user AS u
          WHERE u.id IN(
            SELECT rb.receiver_id
            FROM receives_broadcast AS rb
            WHERE rb.broadcast_id = %s
          ) AND u.id NOT IN (
            SELECT bu1.blocked_id
            FROM blocks_user AS bu1
            WHERE bu1.blocker_id = %s
          ) AND u.id NOT IN (
            SELECT bu2.blocker_id
            FROM blocks_user AS bu2
            WHERE bu2.blocked_id = %s
          )
        )
      ", $text, $selectedId, $userId, $selectedId, $userId, $userId));

      done($results);
    } 

    if ($p == "person") {
      $results = $db->run(sprintf("      
        INSERT INTO message(text) VALUES ('%s');
        INSERT INTO sends_user VALUES (%s, %s, LAST_INSERT_ID());
      ", $text, $selectedId, $userId));

      done($results);
    } 

    if ($p == "group") {
      $results = $db->run(sprintf("      
        INSERT INTO message(text) VALUES ('%s');
        INSERT INTO sends_group VALUES (%s, %s, LAST_INSERT_ID());
      ", $text, $selectedId, $userId));

      done($results);
    }
  }

  if ($q == "get_contacts") {
    $userId = $_POST["user_id"];
    $results = $db->run(sprintf("      
      SELECT *
      FROM user 
      WHERE id <> %s AND id NOT IN (
        SELECT blocked_id
        FROM blocks_user
        WHERE blocker_id = id
        UNION
        SELECT blocker_id
        FROM blocks_user
        WHERE blocked_id = id
      )
    ", $userId));

    done($results);
  }

  if ($q == "create") {

    $p = $_POST["p"];
    $ids = $_POST["ids"];
    $userId = $_POST["user_id"];

    if (strlen($ids) == 0)
      error("No users were selected");

    if ($p == "broadcast") {
      $query = sprintf("
        INSERT INTO broadcast(sender_id) VALUES (%s);
        INSERT INTO receives_broadcast VALUES 
        ", $userId);

      $parts = explode(" ", $_POST["ids"]);
      foreach ($parts as $index => $part) {
        if (strlen($part) != 0) {
          if ($index > 0) {
            $query .= ",";
          }
          $query .= sprintf("(LAST_INSERT_ID(), %s)", $part);
        }
      }

      $results = $db->run($query);
      $results = $db->run(" 
        SELECT rb.broadcast_id AS id, u.name 
        FROM user AS u
        JOIN receives_broadcast AS rb
          ON u.id = rb.receiver_id AND rb.broadcast_id =(
            SELECT MAX(b.id)
            FROM broadcast AS b 
          )
        ");

      done($results);
    }

    if ($p == "group") {
      $name = $_POST["name"];

      if (strlen($name) == 0) 
        error("Name field is empty");

      if (strlen($ids) == 0)
        error("No users were selected");

      $query = sprintf("
        INSERT INTO `group`(name) VALUES ('%s');
        INSERT INTO `joins_group` VALUES 
        (%s, LAST_INSERT_ID(), true)
        ", $name, $userId);

      $parts = explode(" ", $ids);
      foreach ($parts as $part) {
        if (strlen($part) != 0) {
          $query .= sprintf(",(%s, LAST_INSERT_ID(), false)", $part);
        }
      }

      $results = $db->run($query);
      $results = $db->run(" 
        SELECT id, name
        FROM `group`
        ORDER BY id DESC
        LIMIT 1
      ");

      done($results);
    }
  }

  if ($q == "get_settings") {

    $p = $_POST["p"];
    $userId = $_POST["user_id"];
    $selectedId = $_POST["selected_id"];

    if ($p == "broadcast") {
      $results = $db->run(sprintf("      
        SELECT u.id, u.name, u.phone
        FROM user AS u
        JOIN receives_broadcast AS rb 
          ON rb.receiver_id = u.id 
          AND rb.broadcast_id = %s;
      ", $selectedId));

      done($results);
    } 

    if ($p == "person") {
      $results = $db->run(sprintf("
        SELECT SUM(bu.blocker_id = %s) AS is_blocker, SUM(bu.blocked_id = %s) AS is_blocked
        FROM blocks_user AS bu
        WHERE (bu.blocker_id = %s AND bu.blocked_id = %s)
           OR (bu.blocked_id = %s AND bu.blocker_id = %s);
      ", $userId, $userId, $userId, $selectedId, $userId, $selectedId));

      done($results);
    } 

    if ($p == "group") {
      $results = $db->run(sprintf("      
        SELECT u.id, u.name, u.phone, jg.is_admin
        FROM user AS u
        JOIN joins_group AS jg
          ON jg.user_id = u.id
          AND jg.group_id = %s;
      ", $selectedId));

      done($results);
    }
  }

  if ($q == "delete_chat") {

    $p = $_POST["p"];
    $userId = $_POST["user_id"];
    $selectedId = $_POST["selected_id"];

    if ($p == "broadcast") {
      $results = $db->run(sprintf("      
        DELETE FROM sends_user
        WHERE message_id IN (
          SELECT sb.message_id
          FROM sends_broadcast AS sb 
          WHERE sb.broadcast_id = %s
        );

        DELETE FROM sends_broadcast
        WHERE broadcast_id = %s;

        DELETE FROM message
        WHERE id NOT IN (
            SELECT sb.message_id
            FROM sends_broadcast AS sb
        ) AND id NOT IN (
            SELECT su.message_id
            FROM sends_user AS su 
        ) AND id NOT IN (
            SELECT sg.message_id
            FROM sends_group AS sg
        )
      ", $selectedId, $selectedId));

      done($results);
    }

    if ($p == "person") {
      $results = $db->run(sprintf("
        DELETE FROM sends_user
        WHERE (sender_id = %s AND receiver_id = %s) OR 
              (receiver_id = %s AND sender_id = %s);

        DELETE FROM message
        WHERE id NOT IN (
            SELECT sb.message_id
            FROM sends_broadcast AS sb
        ) AND id NOT IN (
            SELECT su.message_id
            FROM sends_user AS su 
        ) AND id NOT IN (
            SELECT sg.message_id
            FROM sends_group AS sg
        )
      ", $userId, $selectedId, $userId, $selectedId));

      done($results);
    } 

    if ($p == "group") {
      $results = $db->run(sprintf("      
        DELETE FROM sends_group
        WHERE group_id = %s;

        DELETE FROM message
        WHERE id NOT IN (
            SELECT sb.message_id
            FROM sends_broadcast AS sb
        ) AND id NOT IN (
            SELECT su.message_id
            FROM sends_user AS su 
        ) AND id NOT IN (
            SELECT sg.message_id
            FROM sends_group AS sg
        )
      ", $selectedId));

      done($results);
    }
  }


  if ($q == "delete") {

    $p = $_POST["p"];
    $selectedId = $_POST["selected_id"];

    if ($p == "broadcast") {
      $results = $db->run(sprintf("      
        DELETE FROM sends_broadcast
        WHERE broadcast_id = %s;

        DELETE FROM receives_broadcast
        WHERE broadcast_id = %s;

        DELETE FROM broadcast 
        WHERE id = %s;

        DELETE FROM message
        WHERE id NOT IN (
            SELECT sb.message_id
            FROM sends_broadcast AS sb
        ) AND id NOT IN (
            SELECT su.message_id
            FROM sends_user AS su 
        ) AND id NOT IN (
            SELECT sg.message_id
            FROM sends_group AS sg
        );
      ", $selectedId, $selectedId, $selectedId));

      done($results);
    }

    if ($p == "group") {
      $results = $db->run(sprintf("      
        DELETE FROM joins_group
        WHERE group_id = %s;

        DELETE FROM sends_group
        WHERE group_id = %s;

        DELETE FROM `group`
        WHERE id = %s;

        DELETE FROM message
        WHERE id NOT IN (
            SELECT sb.message_id
            FROM sends_broadcast AS sb
        ) AND id NOT IN (
            SELECT su.message_id
            FROM sends_user AS su 
        ) AND id NOT IN (
            SELECT sg.message_id
            FROM sends_group AS sg
        );
      ", $selectedId, $selectedId, $selectedId));

      done($results);
    }
  }


  if ($q == "block_user") {

    $userId = $_POST["user_id"];
    $selectedId = $_POST["selected_id"];

    $results = $db->run(sprintf("      
      INSERT INTO blocks_user(blocker_id, blocked_id) 
      VALUES (%s, %s)
    ", $userId, $selectedId));

    done($results);
 
  }

   if ($q == "unblock_user") {

    $userId = $_POST["user_id"];
    $selectedId = $_POST["selected_id"];

    $results = $db->run(sprintf("      
      DELETE FROM blocks_user 
      WHERE blocker_id = %s AND blocked_id = %s
    ", $userId, $selectedId));

    done($results);
 
  }


   if ($q == "leave_group") {

    $userId = $_POST["user_id"];
    $selectedId = $_POST["selected_id"];

    $results = $db->run(sprintf("      
       DELETE FROM joins_group
       WHERE user_id = %s AND group_id = %s
    ", $userId, $selectedId));

    done($results);
 
  }


  if ($q == "update_group_name") {
    $selectedId = $_POST["selected_id"];
    $name = $_POST["name"];

    if (strlen($name) >= 30 || strlen($name) < 2) 
      error("Empty name field or not in range 2..30 letters");

    $results = $db->run(sprintf(" 
      UPDATE `group`
      SET name = '%s'
      WHERE id = %s;
      ", 
      $name, $selectedId));

    done();
  }


  // only on debug
  done($db->run("select * from user"));

} catch (\Throwable $th) {
  echo $th;

}


function error($msg)
{
  die(sprintf('[{"m":"%s"}]', $msg));
}

function done($arrayOfMaps=[[""=>""]])
{
  die(json_encode($arrayOfMaps));
}


class Database extends PDO
{
  public function __construct()
  {
    // Create database if not exists
    $conn = mysqli_connect("localhost", "root", "");
    $conn->query(" create database if not exists goat ");
    $conn->close();

    // Connect to database
    parent::__construct("mysql:host=localhost;dbname=goat", "root", "");
    $this->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // 1. user
    $this->run(
      "
      create table if not exists `user` (
      `id` int AUTO_INCREMENT PRIMARY KEY,
      `name` varchar(30) NOT NULL,
      `phone` char(11) NOT NULL
      );
      "
    );

    // 2. group 
    $this->run(
      "
      create table if not exists `group` (
      `id` int AUTO_INCREMENT PRIMARY KEY,
      `name` varchar(30) NOT NULL
      );
      "
    );

    // 3. broadcast
    $this->run(
      "
      create table if not exists `broadcast` (
      `id` int AUTO_INCREMENT PRIMARY KEY,
      `sender_id` int not null,
      FOREIGN KEY (`sender_id`) REFERENCES `user`(`id`)
      );
      "
    );

    // 4. blocks_user
    $this->run(
      "
      create table if not exists `blocks_user` (
      `blocked_id` int not null,
      `blocker_id` int not null,
      FOREIGN KEY (`blocked_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`blocker_id`) REFERENCES `user`(`id`)
      );
      "
    );

    // 5. message
    $this->run(
      "
      create table if not exists `message` (
      `id` int AUTO_INCREMENT PRIMARY KEY,
      `text` varchar(1000) not null,
      `timestamp` timestamp
      );
      "
    );

    // 6. sends_user
    $this->run(
      "
      create table if not exists `sends_user` (
      `receiver_id` int not null,
      `sender_id` int not null,
      `message_id` int not null,
      FOREIGN KEY (`receiver_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`sender_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`message_id`) REFERENCES `message`(`id`)
      );
      "
    );

    // 7. joins_group
    $this->run(
      "
      create table if not exists `joins_group` (
      `user_id` int not null,
      `group_id` int not null,
      `is_admin` boolean not null,
      FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`group_id`) REFERENCES `group`(`id`)
      );
      "
    );

    // 8. receives_broadcast
    $this->run(
      "
      create table if not exists `receives_broadcast` (
      `broadcast_id` int not null,
      `receiver_id` int not null,
      FOREIGN KEY (`broadcast_id`) REFERENCES `broadcast`(`id`),
      FOREIGN KEY (`receiver_id`) REFERENCES `user`(`id`)
      );
      "
    );

    // 9. sends_group
    $this->run(
      "
      create table if not exists `sends_group` (
      `group_id` int not null,
      `sender_id` int not null,
      `message_id` int not null,
      FOREIGN KEY (`group_id`) REFERENCES `group`(`id`),
      FOREIGN KEY (`sender_id`) REFERENCES `user`(`id`),
      FOREIGN KEY (`message_id`) REFERENCES `message`(`id`)
      );
      "
    );

    // 10. sends_broadcast
    $this->run(
      "
      create table if not exists `sends_broadcast` (
      `broadcast_id` int not null,
      `message_id` int not null,
      FOREIGN KEY (`broadcast_id`) REFERENCES `broadcast`(`id`),
      FOREIGN KEY (`message_id`) REFERENCES `message`(`id`)
      );
      "
    );

  }

  // @param $query SQL Query to run
  public function run($query) : array|bool
  {
    $results = $this->prepare($query, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
    $results->execute();
    return $results->fetchAll();
  }
}
