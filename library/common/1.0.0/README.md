# Common Library

## Values flow

Values are applied with this order, the last overrides the previous.

- common/values.yaml
- chart/ix-values.yaml
- chart/questions.yaml

This is so we can set some sane defaults values on the common library, but have the option
to override those when developing a new chart. And lastly, end user can override those, based
on the interface we create on the `questions.yaml`