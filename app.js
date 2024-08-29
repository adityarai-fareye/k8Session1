const express = require('express')
const app = express()
const PORT = 3333

app.get('/', (request, response) => {
    console.log("1")
    response.send('Default Route')
})

app.listen(PORT, () => console.log('server running on: ',PORT))

// gitleaks detect --redact -v --exit-code=2 --report-format=sarif --report-path=results.sarif --log-level=debug --log-opts=--no-merges --first-parent e73a44d998131a96a95fd00b6be333ad5bb3dc09^..cc0500ead834e28c7c21f1a0c05f365946dbc6ac
// gitleaks detect --redact -v --exit-code=2 --report-format=sarif --report-path=results.sarif --log-level=debug --log-opts=--no-merges --first-parent e73a44d998131a96a95fd00b6be333ad5bb3dc09^..6c771c253873a14133344cb4f58747201bded063