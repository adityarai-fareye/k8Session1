const express = require('express')
const app = express()
const PORT = 3333

const session = "276d586c4432d29c6954a9d23c69843c5d75d127"

app.get('/', (request, response) => {
    response.send('Default Route')
})

app.listen(PORT, () => console.log('server running on: ',PORT))