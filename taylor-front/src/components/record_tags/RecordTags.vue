<template>
  <div class="container">
    <div class="alert alert-warning" v-if="error">{{ error }}</div>
    <div class="jumbotron">
      <h3 class="display-5">言語やコンテンツの種類を追加してください！</h3>
      <form action="" @submit.prevent="addTag">
        <div class="form-group">
          <input class="input form-control"
            autofocus autocomplete="off"
            placeholder="ここに打ってね"
            v-model="newTag.name" />
        </div>
        <input type="submit" value="追加する" class="btn btn-outline-info" />
      </form>
    </div>
    <hr class="" />

    <ul class="row">
      <li class="col-md-3 m-4" v-for="tag in tags" :key="tag.id" :tag="tag" style="list-style: none;">

        <div class="">
          <p class="">
            {{ tag.name }}
          </p>

          <button class="btn btn-secondary"
          @click.prevent="editTag(tag)">Edit</button>

          <button class="btn btn-danger"
         @click.prevent="removeTag(tag)">Delete</button>
        </div>

        <div v-if="tag == editedTag">
          <form action="" @submit.prevent="updateTag(tag)">
            <div class="btn-group-vertical m-3">
              <input class="input form-control" v-model="tag.name" />
              <input type="submit" value="更新する" class="btn btn-secondary">
            </div>
          </form>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'RecordTags',
  data () {
    return {
      tags: [],
      newTag: [],
      error: '',
      editedTag: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/api/v1/record_tags')
        .then(response => { this.tags = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addTag () {
      const value = this.newTag
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/record_tags/', { record_tag: { name: this.newTag.name } })
        .then(response => {
          this.tags.push(response.data)
          this.newTag = ''
        })
        .catch(error => this.setError(error, 'Cannot create Tag'))
    },
    removeTag (tag) {
      this.$http.secured.delete(`/api/v1/record_tags/${tag.id}`)
        .then(response => {
          this.tags.splice(this.tags.indexOf(tag), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete Tag'))
    },
    editTag (tag) {
      this.editedTag = tag
    },
    updateTag (tag) {
      this.editedTag = ''
      this.$http.secured.patch(`/api/v1/record_tags/${tag.id}`, { record_tag: { name: tag.name } })
        .catch(error => this.setError(error, 'Cannot update Tag'))
    }
  }
}
</script>
