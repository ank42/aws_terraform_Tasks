resource "aws_s3_bucket" "storage" {
  bucket = "my-bucket-for-tf-state"
  acl    = "private"
  versioning {
    enabled = true
  }

  tags = {
    Name        = "my-bucket"
    Environment = "Dev"
  }
}

resource "aws_dynamodb_table" "statestorage" {
  name           = "for_state_lock"
  hash_key       = "LockID"
  read_capacity  = "8"
  write_capacity = "8"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "StateLock"
  }
  depends_on = [aws_s3_bucket.storage]
}
