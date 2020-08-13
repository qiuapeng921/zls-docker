<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>程序版本信息</title>
    <link rel="stylesheet" href="//docs.73zls.com/static/light.min.css">
</head>
<body>
<?php
echo '<h3><a href="/tools/adminer.php">数据库管理</a></h3>';
echo '<h2>程序版本信息</h2>';
echo '<ul>';
echo '<li>Nodejs版本：10.16.0</li>';
echo '<li>Nginx版本：', $_SERVER['SERVER_SOFTWARE'], '</li>';
echo '<li>MySQL服务器版本：', getMysqlVersion(), '</li>';
echo '<li>Redis服务器版本：', getRedisVersion(), '</li>';
echo '<li>PHP版本：', PHP_VERSION, '</li>';
echo '</ul>';

echo '<h2>已安装的php扩展</h2>';
printExtensions();

/**
 * 获取MySQL版本
 */
function getMysqlVersion()
{
    if (extension_loaded('PDO_MYSQL')) {
        try {
            $dbh = new PDO('mysql:host=mysql;dbname=mysql', 'root', $_SERVER['MYSQL_ROOT_PASSWORD']??'');
            $sth = $dbh->query('SELECT VERSION() as version');
            $info = $sth->fetch();
        } catch (PDOException $e) {
            if(strpos($e->getMessage(), 'getaddrinfo failed: Name ')){
                return "Mysql 没有启动";
            }
            return $e->getMessage();
        }
        return $info['version'];
    } else {
        return 'PDO_MYSQL 扩展未安装 ×';
    }

}

/**
 * 获取Redis版本
 */
function getRedisVersion()
{
    if (extension_loaded('redis')) {
        try {
            $redis = new Redis();
            $redis->connect('redis', 6379);
            $redis->auth($_SERVER['REDIS_PASSWORD'] ?? '');
            /** @var array $info */
            $info = $redis->info();
            return $info['redis_version'];
        } catch (Exception $e) {
            if(strpos($e->getMessage(), 'Name does not resolve')){
                return "Redis 没有启动";
            }
            return $e->getMessage();
        }
    } else {
        return 'Redis 扩展未安装 ×';
    }
}

/**
 * 获取已安装扩展列表
 */
function printExtensions()
{
    echo '<ol>';
    foreach (get_loaded_extensions() as $i => $name) {
        echo "<li>", $name, '=', phpversion($name), '</li>';
    }
    echo '</ol>';
}
?>

</body>
</html>
