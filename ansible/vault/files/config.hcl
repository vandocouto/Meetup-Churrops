
storage "mysql" {
  address  = "db:3306"
  database = "vault"
  username = "root"
  password = "vault"
}

//listener "tcp" {
//  address = "0.0.0.0:8200"
//  tls_disable = 1
//}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "/vault/config/cert.pem"
  tls_key_file = "/vault/config/key.pem"
}

disable_mlock = true