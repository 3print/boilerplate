export default {
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
      },
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
      },
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
      },
    },

    string: {
      limit: {
        label: 'Limite de taille',
        placeholder: 'aucune limite',
      },

      textarea: {
        label: 'Texte multiligne',
      },
    },
  },
};
