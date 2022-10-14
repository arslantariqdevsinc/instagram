require 'rails_helper'

RSpec.describe "Comments", type: :request do

  let(:user) { create(:user) }
  let!(:test_post) { create(:post) }


  describe "GET /create" do
    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'valid post' do
        context 'and attributes are present' do
          context 'having valid attributes' do
            let(:valid_attributes) {
              { body: "Valid Comment data",  parent_id: nil }
            }

            context 'turbo request' do
              it 'creates a new comment and appends' do
                expect{
                  post post_comments_url(test_post,format: :turbo_stream), params: { comment: valid_attributes }
                }.to change(Comment, :count ).by(1)

                expect(response).to have_http_status(200)
                expect(response.body).to include("<turbo-stream action=#{%Q["append"]}")
                expect(response.body).to include("<turbo-frame id=#{%Q["comment_#{Comment.last.id}"]}")
              end
            end

            context 'html request' do
              it 'creates a new comment' do
                expect{
                  post post_comments_path(test_post), params: { comment: valid_attributes }
                }.to change(Comment, :count ).by(1)

                expect(response).to have_http_status(302)
                expect(response).to redirect_to(test_post)
              end
            end
          end

          context 'having invalid attributes' do
            let(:invalid_attributes) {
              { body: '', parent_id: nil }
            }
            context 'turbo request' do
              it 'updates the form with errors' do
                expect{
                  post post_comments_url(test_post,format: :turbo_stream), params: { comment: invalid_attributes }
                }.to change(Comment, :count ).by(0)

                expect(response).to have_http_status(200)
                expect(response.body).to include("<turbo-stream action=#{%Q["replace"]}")
              end
            end

            context 'html request' do
              it 'redirects to the post' do
                expect{
                  post post_comments_path(test_post), params: { comment: invalid_attributes }
                }.to change(Comment, :count ).by(0)

                expect(response).to have_http_status(302)
              end
            end
          end
        end

        context 'and attributes are not present' do
          it 'does not create a new comment' do
            expect{
              post post_comments_path(test_post)
            }.to raise_error(ActionController::ParameterMissing)
          end
        end
      end

      context 'and invalid post' do
        it 'redirects back' do
          post post_comments_url(Post.maximum(:id) + 1)

          expect(response).to have_http_status(302)
        end
      end

    end

    context 'when not authenticated' do
      it 'redirects to login page' do
        post post_comments_url(test_post)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /edit" do
    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'and valid comment' do
        context 'and authorized' do
          let(:comment) { create(:comment, post: test_post, user: user)}

          it 'render an editing form' do
            get edit_comment_path(comment)

            expect(response).to have_http_status(:ok)
            expect(response.body).to include("<turbo-frame id=#{%Q["comment_#{comment.id}"]}")
            expect(response.body).to include("form id=#{%Q["comment_#{comment.id}"]}")
          end
        end

        context 'and not authorized' do
          let(:not_my_comment) { create(:post) }

          it 'is not alllowed to edit' do
            get edit_comment_path(not_my_comment)

            expect(response).to have_http_status(302)
          end
        end
      end

      context 'and invalid comment' do
        let!(:comment) { create(:comment, post: test_post, user: user)}

        it 'redirects back' do
          get edit_comment_path(Comment.exists? ? Comment.maximum(:id) + 1 : 1)

          expect(response).to have_http_status(302)
        end
      end
    end

    context 'when not authenticated' do
      let(:comment) { create(:comment, post: test_post, user: user)}

      it 'redirects to login page' do
        get edit_comment_path(comment)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  describe "POST /update" do
    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'valid comment' do
        let(:valid_comment) do
          create(:comment, post: test_post, user: user)
        end

        context 'and authorized' do
          context 'and attributes are present' do
            context 'having valid attributes' do
              let(:new_attributes) {
                { body: "Updated comment", parent_id: nil }
              }

              context 'turbo request' do
                it 'updates the request comment' do

                  patch comment_path(valid_comment, format: :turbo_stream), params: { comment: new_attributes }
                  valid_comment.reload


                  comment_id = %Q["comment_#{Comment.last.id}"]
                  action = %Q["replace"]

                  expect(response).to have_http_status(200)
                  expect(response.body).to include("<turbo-stream action=#{action}")
                  expect(response.body).to include("<turbo-frame id=#{comment_id}")
                  expect(response.body).to include(new_attributes[:body])
                end
              end

              context 'html request' do
                it 'updates the requested comment' do
                  patch comment_path(valid_comment), params: { comment: new_attributes }
                  valid_comment.reload

                  expect(response).to have_http_status(302)
                  expect(response).to redirect_to(valid_comment)
                end
              end
            end

            context 'having invalid attributes' do
              let(:invalid_attributes) {
                { body: '', parent_id: nil }
              }
              context 'with invalid params' do
                context 'turbo request' do
                  it 'updates the form with errors' do

                    patch comment_path(valid_comment, format: :turbo_stream), params: { comment: invalid_attributes }
                    valid_comment.reload

                    action = %Q["replace"]
                    comment_id = %Q["comment_#{valid_comment.id}"]

                    expect(response.body).to include("<turbo-stream action=#{action}")
                    expect(response.body).to include("target=#{comment_id}")
                    expect(response.body).to include("<form id=#{comment_id}")
                  end
                end

                context 'html request' do
                  it 'renders the edit form' do
                    patch comment_path(valid_comment), params: { comment: invalid_attributes }
                    valid_comment.reload

                    expect(response).to have_http_status(:unprocessable_entity)
                  end
                end
              end

              context 'with invalid comment' do

                it "redirects back" do
                  patch comment_path(Comment.exists? ? Comment.maximum(:id) + 1 : 1)

                  expect(response).to have_http_status(302)
                end
              end
            end
          end

          context 'and attributes are not present' do
            it 'throws ParameterMissing exception' do
              expect{
                patch comment_path(valid_comment)
              }.to raise_error(ActionController::ParameterMissing)
            end
          end
        end

        context 'and not authorized' do
          let(:not_my_comment) { create(:post) }

          it 'is not alllowed to edit' do
            patch comment_path(not_my_comment)

            expect(response).to have_http_status(302)
          end
        end

      end

      context 'and invalid comment' do
        it "redirects back" do
          patch comment_path(Comment.exists? ? Comment.maximum(:id) + 1 : 1)

          expect(response).to have_http_status(302)
        end
      end

    end

    context 'when not authenticated' do
      it 'redirects to login page' do
        post post_comments_url(test_post)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


  describe "DELETE /destroy" do
    let!(:comment) { create(:comment, post: test_post, user: user)}

    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'and valid comment' do
        context 'and authorized' do
          context 'turbo request' do
            it 'destroys the requested comment' do
              expect{
                delete comment_path(comment, format: :turbo_stream)
              }.to change(Comment, :count).by(-1)

              comment_id = %Q["comment_#{comment.id}"]
              action = %Q["remove"]

              expect(response).to have_http_status(:ok)
              expect(response.body).to include("<turbo-stream action=#{action}")
              expect(response.body).to include("target=#{comment_id}")
            end
          end

          context 'html request' do
            it 'destroys the requested comment' do
              expect{
                delete comment_path(comment)
              }.to change(Comment, :count).by(-1)

              expect(response).to have_http_status(302)
              expect(response).to redirect_to(comment.post)
            end
          end
        end

        context 'and not authorized' do
          let(:not_my_comment) { create(:post) }

          it 'is not alllowed to delete' do
            delete comment_path(not_my_comment)

            expect(response).to have_http_status(302)
          end
        end
      end

      context 'and invalid comment' do
        it "redirects back" do
          delete comment_path(Comment.exists? ? Comment.maximum(:id) + 1 : 1)

          expect(response).to have_http_status(302)
        end
      end
    end

    context 'when not authenticated' do
      it 'redirects to login page' do
        delete comment_path(comment)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
