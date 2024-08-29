const express = require('express')
const app = express()
const PORT = 3333

const key = "AIzaSyAfHNk2CTX44LJiSKEYy1jmYgSuMk8IABA";

app.get('/', (request, response) => {
    console.log('0')
    response.send('Default Route')
})

app.listen(PORT, () => console.log('server running on: ',PORT))