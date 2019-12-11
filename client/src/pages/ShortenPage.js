import React, { useState } from "react"
import { Form, Button, Alert, Nav, Container, Row, Col, InputGroup, FormControl } from 'react-bootstrap';
import {CopyToClipboard} from 'react-copy-to-clipboard';

export const ShortenPage = () => {
  const [url, setUrl] = useState("")
  const [shortenUrl, setShortenUrl] = useState(null)
  const [error, setError] = useState(null)


  const getShortenUrl = (e) => {
    e.preventDefault()
    setError(null)

    fetch("http://localhost:4567/api/shorten", {
      mode: 'cors',
      method: "POST",
      headers: new Headers({
        'Content-Type': 'application/json'
        }),
      body: JSON.stringify({ url })
    })
    .then(data => data.json())
    .then(response => {
      if (response.error) {
        throw new Error(response.error)
      }

      setShortenUrl(response.url)
    })
    .catch(error => {
      setError(error.message)
    })
  }

  const handleChange = (e) => {
    setUrl(e.target.value)
  }

  return (
    <div>
      <Nav>
        <Nav.Item>
          <Nav.Link href="#/statistics">Statistics</Nav.Link>
        </Nav.Item>
      </Nav>
      <Form onSubmit={getShortenUrl}>
        <Container>
          <Form.Group controlId="url">
            <Row>
              <Col>
                <Form.Label>The URL for shorten</Form.Label>
              </Col>
            </Row>
            <Row>
              <Col>
                <Form.Control type="text" placeholder="Enter url address" value={url} onChange={handleChange} />
              </Col>
            </Row>
          </Form.Group>
          <Row>
            <Col>
              {error && <Alert variant="danger">{error}</Alert>}
            </Col>
          </Row>
          <Row>
            <Col>
              <Button variant="primary" type="submit">
                Submit
              </Button>
            </Col>
          </Row>
        </Container>
      </Form>

      {shortenUrl && (
        <Container className="mt-4">
          <Row>
            <Col>
            <InputGroup className="mb-3">
              <FormControl
                placeholder="shorten url"
                disabled
                value={shortenUrl}
              />
              <InputGroup.Append>
                <CopyToClipboard text={shortenUrl}>
                  <Button variant="outline-secondary" disabled={!shortenUrl}>Copy to buffer</Button>
                </CopyToClipboard>
              </InputGroup.Append>
            </InputGroup>
            </Col>
          </Row>
        </Container>
      )}
    </div>
    )
}
