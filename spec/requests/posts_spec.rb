require 'rails_helper'

RSpec.describe "Posts", type: :request do

  let(:user) { create(:user) }
  let(:subject) { build(:post, user: user)}

  let(:valid_attributes) {
    { body: "Valid Post data", images: [ fixture_file_upload(file_fixture('instagram.png')) ]}
  }

  let(:invalid_attributes) {
    { body: "", images: [ fixture_file_upload(file_fixture('instagram.png')) ]}

  }

  describe "GET /index" do

    context 'when authenticated/unauthenticated' do

      it 'redirects to Posts page' do

        get posts_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('posts_grid')
      end
    end
  end

  describe "GET /show" do
    before do
      subject.save
    end

    context 'when valid post' do

      it "renders post detail modal" do

        get post_path(subject)

        expect(response).to have_http_status(:ok)
        expect(response).to be_successful
        expect(response.body).to include("post_detail#{subject.id}")
      end
    end

    context 'when invalid post' do

      it "redirects back" do

        get post_path(Post.maximum(:id) + 1)

        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET /new" do

    context 'when authenticated' do

      before do
        sign_in user
      end

      it 'renders a new form' do
        get new_post_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Create new post')

      end
    end

    context 'when not authenticated' do
      it 'redirects to login page' do
        get new_post_path

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /edit" do
    context 'when authenticated' do

      before do
        sign_in user
        subject.save
      end

      context 'and invalid post' do

        it "redirects back" do

          get post_path(Post.maximum(:id) + 1)

          expect(response).to have_http_status(302)
        end
      end

      context 'and valid post' do

        it 'render an editing form' do

          get edit_post_path(subject)

          expect(response).to have_http_status(:ok)
          expect(response.body).to include('Editing Post')
        end
      end

    end

    context 'when not authenticated' do
      before do
        subject.save
      end

      it 'redirects to login page' do

        get edit_post_path(subject)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /create" do

    context 'when authenticated' do
      before(:each) do
        sign_in user
        subject.save
      end

      context 'and attributes are present' do

        context 'having valid attributes' do

          it 'creates a new post' do
            expect{
              post posts_path, params: { post: valid_attributes }
            }.to change(Post, :count).by(1)

            expect(response).to redirect_to(posts_path)

          end
        end

        context 'having invalid attributes' do

          it 'does not create a new post' do
            expect{
              post posts_path, params: { post: invalid_attributes }
            }.to change(Post, :count).by(0)

            expect(response.body).to include('Create new post')

          end
        end
      end

      context 'and attributes are missing' do

        it 'raises ParameterMissing exception' do
          expect{
            post posts_path
          }.to raise_error(ActionController::ParameterMissing)
        end
      end
    end

    context 'when not authenticated' do

      it 'redirects to login page' do

        post posts_path, params: { post: valid_attributes }

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /update" do

    let(:valid_post){
      create(:post, valid_attributes.merge(user: user))
    }

    context 'when authenticated' do
      before(:each) do
        sign_in user
      end

      context 'and valid post' do

        context 'and attributes are present' do

          context 'having valid attributes' do

            let(:new_attributes) {
              { body: "New Valid Post data", images: [ fixture_file_upload(file_fixture('instagram.png')) ]}
            }

            it 'updates the requested post' do

              patch post_path(valid_post), params: { post: new_attributes }
              valid_post.reload

              expect(response).to redirect_to post_path(valid_post)
            end
          end

          context 'having invalid attributes' do

            it 'renders the edit form' do
              patch post_path(valid_post), params: { post: invalid_attributes }
              valid_post.reload

              expect(response.body).to include('Editing Post')
            end
          end
        end

        context 'and attributes are missing' do

          it 'renders the edit form' do
            expect{
              post posts_path
            }.to raise_error(ActionController::ParameterMissing)
          end

        end

      end

      context 'and invalid post' do

        it "redirects back" do

          subject.save
          patch post_path(Post.maximum(:id) + 1)

          expect(response).to have_http_status(302)
        end
      end
    end

    context 'when not authenticated' do

      it 'redirects to login page' do

        patch post_path(valid_post), params: { post: invalid_attributes }

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /destroy" do

    context 'when authenticated' do

      before do
        sign_in user
        subject.save
      end

      context 'and valid post' do

        it "destroys the requested post" do

          expect {
            delete post_path(subject)
          }.to change(Post, :count).by(-1)

        end
      end

      context 'and invalid post' do

        it "redirects back" do

          delete post_path(Post.maximum(:id) + 1)

          expect(response).to have_http_status(302)
        end
      end
    end

    context 'when not authenticated' do

      it 'redirects to login page' do

        subject.save
        delete post_path(subject)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
