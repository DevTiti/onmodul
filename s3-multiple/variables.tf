variable "region" {
  type= string
  default = "eu-central-1"
}

# Variable Declaration for bucket
variable "bucket_list" {
  type = list
  default = ["onmodul-bucket-2023a","onmodul-bucket-2023b","onmodul-bucket-2023c"]

}

