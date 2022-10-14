require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }

  describe 'GET /index' do
    context 'when authenticated/unauthenticated' do
      it 'redirects to Posts page' do
        get posts_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('posts_grid')
      end
    end
  end

  describe 'GET /show' do
    let(:user_post) { create(:post, user: user) }

    before do
      user_post.save
    end

    context 'when valid post' do
      it 'renders post detail modal' do
        get post_path(user_post)

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("<turbo-frame id=#{%Q["detail"]}")
        expect(response.body).to include("post_detail#{user_post.id}")
      end
    end

    context 'when invalid post' do
      it 'redirects back' do
        get post_path(Post.exists? ? Post.maximum(:id) + 1 : 1)

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'GET /new' do
    context 'when authenticated' do
      before do
        sign_in user
      end

      it 'renders a new form' do
        get new_post_path

        expect(response).to have_http_status(:ok)
        "<turbo-stream action=#{%Q["replace"]}"
        expect(response.body).to include("<turbo-frame id=#{%Q["modal"]}")
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

  describe 'GET /edit' do
    let(:user_post) { create(:post, user: user) }

    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'and invalid post' do
        it 'redirects back' do
          get post_path(Post.exists? ? Post.maximum(:id) + 1 : 1)

          expect(response).to have_http_status(302)
        end
      end

      context 'and valid post' do
        context 'and authorized' do
          it 'render an editing form' do
            get edit_post_path(user_post)

            expect(response).to have_http_status(:ok)
            expect(response.body).to include("<turbo-frame id=#{%Q["modal"]}")
            expect(response.body).to include('Editing Post')
          end
        end

        context 'and not authorized' do
          let(:not_my_post) { create(:post) }

          it 'is not allowed to edit' do
            get edit_post_path(not_my_post)

            expect(response).to have_http_status(302)
          end
        end
      end
    end

    context 'when not authenticated' do
      before do
        user_post.save
      end

      it 'redirects to login page' do
        get edit_post_path(user_post)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /create' do
    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'and attributes are present' do
        context 'having valid attributes' do
          let(:valid_attributes) do
            { body: 'Valid Post data', images: [fixture_file_upload(file_fixture('instagram.png'))] }
          end

          context 'turbo request' do
            it 'creates a new post and appends' do
              expect  do
                post posts_path(format: :turbo_stream), params: { post: valid_attributes }
              end.to change(Post, :count).by(1)

              expect(response).to have_http_status(200)
              expect(response.body).to include("<turbo-stream action=#{%Q["prepend"]}")
              expect(response.body).to include('id = ' + %Q["post-#{Post.last.id}"])
              expect(response.body).to include('id = ' + %Q["posts-feed-#{Post.last.id}"])
            end
          end

          context 'html request' do
            it 'creates a new post' do
              expect  do
                post posts_path, params: { post: valid_attributes }
              end.to change(Post, :count).by(1)

              expect(response).to have_http_status(302)
              expect(response).to redirect_to(posts_path)
            end
          end
        end

        context 'having invalid attributes' do
          let(:invalid_attributes) do
            {
              body: '',
              images: [fixture_file_upload(file_fixture('instagram.png'))]
            }
          end

          it 'does not create a new post' do
            expect  do
              post posts_path, params: { post: invalid_attributes }
            end.to change(Post, :count).by(0)

            expect(response.body).to include("<turbo-frame id=#{%Q["modal"]}")
            expect(response.body).to include('Create new post')
          end
        end
      end

      context 'and attributes are missing' do
        it 'raises ParameterMissing exception' do
          expect  do
            post posts_path
          end.to raise_error(ActionController::ParameterMissing)
        end
      end
    end

    context 'when not authenticated' do
      it 'redirects to login page' do
        post posts_path

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /update' do
    let(:valid_attributes) do
      { body: 'Valid Post data',
        images: [fixture_file_upload(file_fixture('instagram.png'))] }
    end

    let!(:valid_post)  do
      create(:post, valid_attributes.merge(user: user))
    end

    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'and valid post' do
        context 'and authorized' do
          context 'and attributes are present' do
            context 'having valid attributes' do
              let(:new_attributes) do
                { body: 'Updated valid Post data', images: [fixture_file_upload(file_fixture('instagram.png'))] }
              end

              context 'turbo request' do
                it 'updates the requested post' do
                  patch post_path(valid_post.id, format: :turbo_stream), params: { post: new_attributes }

                  expect(response).to have_http_status(200)
                  expect(response.body).to include("<turbo-stream action=#{%Q["replace"]}")
                  expect(response.body).to include('id=' + %Q["post_detail#{valid_post.reload.id}"])
                  expect(response.body).to include('id = ' + %Q["posts-feed-#{valid_post.id}"])
                end
              end

              context 'html request' do
                it 'updates the requested post' do
                  patch post_path(valid_post.id), params: { post: new_attributes }
                  valid_post.reload

                  expect(response).to redirect_to post_path(valid_post)
                end
              end
            end

            context 'having invalid attributes' do
              let(:invalid_attributes) do
                {
                  body: '',
                  images: [fixture_file_upload(file_fixture('instagram.png'))]
                }
              end

              it 'renders the edit form' do
                patch post_path(valid_post.id), params: { post: invalid_attributes }
                valid_post.reload

                expect(response.body).to include('Editing Post')
              end
            end
          end

          context 'and attributes are missing' do
            it 'renders the edit form' do
              expect  do
                post posts_path
              end.to raise_error(ActionController::ParameterMissing)
            end
          end
        end

        context 'and not authorized' do
          let(:not_my_post) { create(:post) }

          it 'is not allowed to update' do
            patch post_path(not_my_post)

            expect(response).to have_http_status(302)
          end
        end
      end

      context 'and invalid post' do
        it 'redirects back' do
          patch post_path(Post.exists? ? Post.maximum(:id) + 1 : 1)

          expect(response).to have_http_status(302)
        end
      end
    end

    context 'when not authenticated' do
      it 'redirects to login page' do
        patch post_path(valid_post)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:user_post) { create(:post, user: user) }

    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'and valid post' do
        context 'and authorized' do
          context 'turbo request' do
            it 'destroys the requested post' do
              expect do
                delete post_path(user_post, format: :turbo_stream)
              end.to change(Post, :count).by(-1)

              expect(response.body).to include("<turbo-stream action=#{%Q["remove"]}")
              expect(response.body).to include('target=' + %Q["posts-feed-#{user_post.id}"])
            end
          end

          context 'html request' do
            it 'destroys the requested post' do
              expect do
                delete post_path(user_post)
              end.to change(Post, :count).by(-1)

              expect(response).to have_http_status(302)
            end
          end
        end

        context 'and not authorized' do
          let!(:not_my_post) { create(:post) }

          it 'is not allowed to delete' do
            expect do
              delete post_path(not_my_post)
            end.to change(Post, :count).by(0)

            expect(response).to have_http_status(302)
          end
        end
      end

      context 'and invalid post' do
        it 'redirects back' do
          delete post_path(Post.exists? ? Post.maximum(:id) + 1 : 1)

          expect(response).to have_http_status(302)
        end
      end
    end

    context 'when not authenticated' do
      it 'redirects to login page' do
        delete post_path(user_post)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
