export default {
  widgets: {
    coordinates: {
      error: "Can't retrieve GPS coordinates for the provided address",
    },
    validation: {
      blank: "This field cannot be blank",
      value_missing: "This field cannot be blank",
      invalid_email: 'Please fill a valid email address',
      password_confirmation_doesnt_match: 'Confirmation does not match password',
      bad_input: 'Bad input',
      pattern_mismatch: 'Value does not match the specified pattern',
      range_overflow: 'Value exceeds the allowed range',
      range_underflow: 'Value is below the allowed range',
      too_long: 'The value is too long',
      too_short: 'The value is too short',
      email_mismatch: 'The value is not a valid email',
      url_mismatch: 'The value is not a valid URL',
    },
    field_limit: {
      remaining: "Remaining characters: #{count}",
    },
    file_preview: {
      label: "Browse…",
    },
    table_header_sort: {
      reset: 'Reset order',
    },
  },

  settings_input: {
    required: {
      label: 'Required field',
    },

    collection: {
      values: {
        label: 'Possible values (comma separated list)',
        placeholder: 'item 1, item 2, item 3',
      },

      multiple: {
        label: 'Many choices available',
      },
    },

    integer: {
      default: {
        label: 'Default Value',
        placeholder: '1',
      },

      min: {
        label: 'Minimum value',
        placeholder: '0',
      },

      max: {
        label: 'Maximum value',
        placeholder: '100',
      },

      step: {
        label: 'Step',
        placeholder: '1',
      },
    },

    float: {
      default: {
        label: 'Default Value',
        placeholder: '1',
      },

      min: {
        label: 'Minimum value',
        placeholder: '0',
      },

      max: {
        label: 'Maximum value',
        placeholder: '100',
      },

      step: {
        label: 'Step',
        placeholder: '0.1',
      },
    },

    string: {
      limit: {
        label: 'Size Limit',
        placeholder: 'no limit',
      },

      textarea: {
        label: 'Multiline text',
      },
    },
  },
};
