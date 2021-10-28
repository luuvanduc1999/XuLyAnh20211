let
Key = "eyJhbGciOiJIUzI1NiJ9.eyJ0aWQiOjExNTA3Nzg0MiwidWlkIjoyMjI3NDY3MSwiaWFkIjoiMjAyMS0wNi0yNlQwNDo1Njo1My4wMDBaIiwicGVyIjoibWU6d3JpdGUiLCJhY3RpZCI6NjM1MjkwNiwicmduIjoidXNlMSJ9.CEL0Nm6_1KORTlKjSwqS-yGjsen-No7ja-Eo_e1P8oI",
Board = "959592919",
Source = Web.Contents(
"https://api.monday.com/v2",
[
Headers=[
#"Method"="POST",
#"Content-Type"="application/json",
#"Authorization"="Bearer " & Key
],
Content=Text.ToBinary("{""query"": ""query { boards(ids: " & Board & ") { items { name, group { title }, columns: column_values { title, text } } } }""}")
]
),
Data = Table.FromList(Json.Document(Source)[data][boards]{0}[items], Record.FieldValues, {"Title", "Group", "Columns"}),
#"Monday" = Table.FromRecords(Table.TransformRows(Data, each
List.Accumulate([Columns], [
Title = [Title],
Group = [Group][title]
], (state, current) => Record.AddField(state, current[title], current[text]) )
))
in
Monday
