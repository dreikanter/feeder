import { freefeedBaseUrl } from 'main/constants'

export default (feedName, postId) => `${freefeedBaseUrl}/${feedName}/${postId}`
