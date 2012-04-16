function result = load_result(string)

result = load(string) ;
fields = fieldnames(result) ;
result = result.(fields{1}) ;

end