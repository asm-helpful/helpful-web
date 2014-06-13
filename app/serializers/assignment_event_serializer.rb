class AssignmentEventSerializer < BaseSerializer
  has_one :user,
    serializer: UserSerializer

  has_one :assignee,
    serializer: UserSerializer
end
