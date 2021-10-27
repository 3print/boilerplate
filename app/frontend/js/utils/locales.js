export const LOCALES = {

  //    ######## ##    ##
  //    ##       ###   ##
  //    ##       ####  ##
  //    ######   ## ## ##
  //    ##       ##  ####
  //    ##       ##   ###
  //    ######## ##    ##
  en: {
    widgets: {
      coordinates: {
        error: "Can't retrieve GPS coordinates for the provided address"
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
        remaining: "Remaining characters: #{count}"
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
        label: 'Mandatory field'
      },

      collection: {
        values: {
          label: 'Possible values (comma separated list)',
          placeholder: 'item 1, item 2, item 3'
        }
      },

      integer: {
        default: {
          label: 'Default Value',
          placeholder: '1'
        },

        min: {
          label: 'Minimum value',
          placeholder: '0'
        },

        max: {
          label: 'Maximum value',
          placeholder: '100'
        },

        step: {
          label: 'Step',
          placeholder: '1'
        }
      },

      float: {
        default: {
          label: 'Default Value',
          placeholder: 1
        },

        min: {
          label: 'Minimum value',
          placeholder: '0'
        },

        max: {
          label: 'Maximum value',
          placeholder: '100'
        },

        step: {
          label: 'Step',
          placeholder: '0.1'
        }
      },

      string: {
        limit: {
          label: 'Size Limit',
          placeholder: 'no limit'
        },

        textarea: {
          label: 'Multiline text'
        }
      }
    }
  },

  //    ######## ########
  //    ##       ##     ##
  //    ##       ##     ##
  //    ######   ########
  //    ##       ##   ##
  //    ##       ##    ##
  //    ##       ##     ##
  fr: {
    widgets: {
      coordinates: {
        error: "Impossible de récupérer les coordonnées GPS de l'adresse indiquée.",
      },
      validation: {
        blank: 'Ce champ ne peut être vide',
        value_missing: 'Ce champ ne peut être vide',
        invalid_email: 'Saisissez une adresse email valide',
        password_confirmation_doesnt_match: 'La confirmation ne correspond pas au mot de passe saisi',
        bad_input: 'La saisie est invalide',
        pattern_mismatch: 'La valeur saisie ne correspond pas au motif demandé',
        range_overflow: 'La valeur excède la plage autorisée',
        range_underflow: 'La valeur est sous la plage autorisée',
        too_long: 'La valeur est trop longue',
        too_short: 'La valeur est trop courte',
        email_mismatch: "La valeur saisie n'est pas un email valide",
        url_mismatch: "La valeur saisie n'est pas une URL valide",
      },
      field_limit: {
        remaining: "Caractères restants : #{count}",
      },
      file_preview: {
        label: "Parcourir…",
      },
      table_header_sort: {
        reset: 'Remettre à zéro le tri',
      },
    },

    settings_input: {
      required: {
        label: 'Champ obligatoire',
      },

      collection: {
        values: {
          label: 'Valeurs possible (liste séparée par des virgules)',
          placeholder: 'item 1, item 2, item 3',
        },

        multiple: {
          label: 'Plusieurs choix possible',
        }
      },

      integer: {
        default: {
          label: 'Valeur par défaut',
          placeholder: '1',
        },

        min: {
          label: 'Valeur minimum',
          placeholder: '0',
        },

        max: {
          label: 'Valeur maximum',
          placeholder: '100',
        },

        step: {
          label: 'Pas',
          placeholder: '1',
        }
      },

      float: {
        default: {
          label: 'Valeur par défaut',
          placeholder: '1',
        },

        min: {
          label: 'Valeur minimum',
          placeholder: '0',
        },

        max: {
          label: 'Valeur maximum',
          placeholder: '100',
        },

        step: {
          label: 'Pas',
          placeholder: '0.1',
        }
      },

      string: {
        limit: {
          label: 'Limite de taille',
          placeholder: 'aucune limite',
        },

        textarea: {
          label: 'Texte multiligne',
        }
      }
    }
  }
};
