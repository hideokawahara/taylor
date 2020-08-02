<template>
  <div class="container">
    <div class="alert alert-warning" v-if="error">{{ error }}</div>
    <h3 class="py-3">情報を入力してね</h3>

    <form @submit.prevent="addRecord" class="form-group m-2">
      <div class="m-3">
        <label for="record_title" class="label">題名</label>
        <input
          type="text"
          id="record_title"
          class="input form-control"
          autofocus
          autocomplete="off"
          placeholder="本の題名を書こう"
          v-model="newRecord.title">
      </div>

      <div class="m-3">
        <label for="record_year" class="label">点数</label>
        <input
          type="text"
          id="record_year"
          class="input form-control"
          autofocus
          autocomplete="off"
          placeholder="本の点数"
          v-model="newRecord.year">
      </div>

      <div class="m-3 janre">
        <label for="tag" class="label">ジャンル</label>
        <select id="tag" class="select" v-model="newRecord.tag">
          <option disabled value="">Select an tag</option>
          <option :value="tag.id" v-for="tag in tags" :key="tag.id">{{ tag.name }}</option>
        </select>
        <p class="pt-4">ジャンルがなければ <router-link to="/record_tags" class="btn btn-success m-3">作ろう</router-link></p>
      </div>

      <input type="submit" value="投稿する" class="btn btn-primary m-3 submit">
    </form>

    <hr class="border border-grey-light my-6" />

    <ul class="row">
      <li class="col-md-3 m-4 rev" v-for="record in records" :key="record.id" :record="record" style="list-style: none;">
        <div class="">
          <div class="">
          <p class="">
            コンテンツの名前:::::
            {{ record.title }}
          </p>
          <p class="ml-4">
            点数:::::
            {{ record.year }}
          </p>
          <p class="ml-5">{{ getTag(record) }}</p>
        </div>

        <button class="btn btn-outline-dark m-2"
          @click.prevent="editRecord(record)">Edit</button>

        <button class="btn btn-dark m-2"
         @click.prevent="removeRecord(record)">Delete</button>
        </div>

        <div v-if="record == editedRecord">
          <form action="" @submit.prevent="updateRecord(record)">
            <div class="mb-6 p-4 bg-white rounded border border-grey-light mt-4">

              <div class="mb-6">
                <label class="label">Title</label>
                <input class="input" v-model="record.title">
              </div>

              <div class="mb-6">
                <label class="label">Year</label>
                <input class="input" v-model="record.year">
              </div>

              <div class="mb-6">
                 <select id="tag_update" class="select" v-model="record.tag">
                    <option disabled value="">Select an tag</option>
                  <option :value="tag.id" v-for="tag in tags" :key="tag.id">{{ tag.name }}</option>
                  </select>
              </div>

              <input type="submit" value="Update" class="bg-transparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded">
            </div>
          </form>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Details',
  data () {
    return {
      tags: [],
      records: [],
      newRecord: [],
      error: '',
      editedRecord: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/api/v1/details')
        .then(response => { this.records = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
      this.$http.secured.get('/api/v1/record_tags')
        .then(response => { this.tags = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    getTag (record) {
      const recordTagValues = this.tags.filter(tag => tag.id === record.record_tag_id)
      let tag
      recordTagValues.forEach(function (element) {
        tag = element.name
      })
      return tag
    },
    addRecord () {
      const value = this.newRecord
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/details/', { detail: { title: this.newRecord.title, year: this.newRecord.year, record_tag_id: this.newRecord.tag } })
        .then(response => {
          this.records.push(response.data)
          this.newRecord = ''
        })
        .catch(error => this.setError(error, 'Cannot create record'))
    },
    removeRecord (record) {
      this.$http.secured.delete(`/api/v1/details/${record.id}`)
        .then(response => {
          this.records.splice(this.records.indexOf(record), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete record'))
    },
    editRecord (record) {
      this.editedRecord = record
    },
    updateRecord (record) {
      this.editedRecord = ''
      this.$http.secured.patch(`/api/v1/details/${record.id}`, { detail: { title: record.title, year: record.year, record_tag_id: record.tag } })
        .catch(error => this.setError(error, 'Cannot update record'))
      location.reload()
    }
  }
}
</script>

<style scoped>
.container {
  background: #4c2a4c;
  color: #ffffff;
  /* margin-bottom: 0; */
  border-radius: 240px 15px 100px 15px / 15px 200px 15px 185px;
  border: 2px dotted rgb(253, 250, 250);
}

.m-3.janre {
    font-weight: bold;
    background: #6d3d6d;
    padding-top: 2rem;
    padding-left: 2rem;
    border-radius: 20px;
    border-style: dashed;
  }

.btn.btn-success.m-3 {
  background: #3c1f3c;
  border-color: gold;
}

.btn.btn-success.m-3:hover {
  background-color: rgb(240, 41, 230);
  color: gold;
  opacity: 0.5;
}

.col-md-3.m-4.rev {
  border-style: dotted;
  border-radius: 60px;
  padding: 1rem;
  background: #6d3d6d;
  font-weight: bold;
}

.btn.btn-primary.m-3.submit {
  background: #7c47c0;
  border-color: gold;
}

.btn.btn-primary.m-3.submit:hover {
  background-color: rgb(160, 41, 240);
  color: gold;
  opacity: 0.5;
}

@media (min-width:768px) {
  .form-group {
    width: 40rem;
    justify-content: center;
  }
  .m-3.janre {
    width: 40%;
    margin-left: 30% !important;
  }
  .btn.btn-primary.m-3.submit {
    margin-left: 70% !important;
  }
  .col-md-3.m-4.rev {
    padding: 2rem;
  }
}
</style>
