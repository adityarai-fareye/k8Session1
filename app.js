const express = require('express')
const app = express()
const PORT = 3333

const key = "AIzaSyAfHNk2CTX44LJiSKEYy1jmYgSuMk8IABA";

app.get('/', (request, response) => {
    // console.log('0')
    response.send('Default Route')
})

app.listen(PORT, () => console.log('server running on: ',PORT))

// gitleaks detect --redact -v --exit-code=2 --report-format=sarif --report-path=results.sarif --log-level=debug --log-opts=--no-merges --first-parent e73a44d998131a96a95fd00b6be333ad5bb3dc09^..3d6334b5a261445b324da6cc29f5e35f81efb269
// gitleaks detect --redact -v --exit-code=2 --report-format=sarif --report-path=results.sarif --log-level=debug --log-opts=--no-merges --first-parent e73a44d998131a96a95fd00b6be333ad5bb3dc09^..20849092156b04953da6648b9f07bd7d53ab13d7